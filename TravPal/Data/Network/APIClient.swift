import Foundation
import Alamofire

protocol APIClientProtocol {
    func perform<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod, body: Body, decode: Response.Type,
        requiresAuth: Bool
    ) async throws -> Response

    func perform<Response: Decodable>(
        path: String, method: HTTPMethod, decode: Response.Type,
        requiresAuth: Bool
    ) async throws -> Response

    func performWithoutPayload<Body: Encodable>(
        path: String, method: HTTPMethod, body: Body, requiresAuth: Bool
    ) async throws
}

// Tetap kompatibel dengan pemanggilan endpoint publik pada AuthRemoteDataSource.
extension APIClientProtocol {
    func perform<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod = .post, body: Body, decode: Response.Type
    ) async throws -> Response {
        try await perform(path: path, method: method, body: body, decode: decode, requiresAuth: false)
    }

    func perform<Response: Decodable>(
        path: String, method: HTTPMethod = .get, decode: Response.Type
    ) async throws -> Response {
        try await perform(path: path, method: method, decode: decode, requiresAuth: false)
    }

    func performWithoutPayload<Body: Encodable>(
        path: String, method: HTTPMethod = .post, body: Body
    ) async throws {
        try await performWithoutPayload(path: path, method: method, body: body, requiresAuth: false)
    }
}

final class APIClient: APIClientProtocol {
    private let session: Session
    private let sessionManager: SessionManager
    private let baseURL: URL

    init(session: Session, sessionManager: SessionManager, baseURL: URL = Constants.apiBaseURL) {
        self.session = session
        self.sessionManager = sessionManager
        self.baseURL = baseURL
    }

    func perform<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod, body: Body, decode: Response.Type,
        requiresAuth: Bool
    ) async throws -> Response {
        let envelope: APIEnvelope<Response> = try await requestEnvelope(
            path: path, method: method, body: body, requiresAuth: requiresAuth
        )
        return try unwrap(envelope)
    }

    func perform<Response: Decodable>(
        path: String, method: HTTPMethod, decode: Response.Type, requiresAuth: Bool
    ) async throws -> Response {
        let envelope: APIEnvelope<Response> = try await requestEnvelope(
            path: path, method: method, body: Optional<EmptyBody>.none, requiresAuth: requiresAuth
        )
        return try unwrap(envelope)
    }

    func performWithoutPayload<Body: Encodable>(
        path: String, method: HTTPMethod, body: Body, requiresAuth: Bool
    ) async throws {
        let envelope: APIEnvelope<EmptyPayload> = try await requestEnvelope(
            path: path, method: method, body: body, requiresAuth: requiresAuth
        )
        guard envelope.isSuccess else {
            throw NetworkError.server(message: envelope.message ?? "Terjadi kesalahan, coba lagi ya.")
        }
    }

    private func unwrap<T>(_ envelope: APIEnvelope<T>) throws -> T {
        guard envelope.isSuccess else {
            throw NetworkError.server(message: envelope.message ?? "Terjadi kesalahan, coba lagi ya.")
        }
        guard let data = envelope.data else { throw NetworkError.invalidResponse }
        return data
    }

    private func requestEnvelope<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod, body: Body?, requiresAuth: Bool
    ) async throws -> APIEnvelope<Response> {
        let authorization = requiresAuth ? try await sessionManager.authorization() : nil
        var response = await send(path: path, method: method, body: body, token: authorization?.token)
        try Task.checkCancellation()

        if let authorization {
            try await sessionManager.validateSession(authorization)
            if response.response?.statusCode == 401 {
                let renewed = try await sessionManager.renew(authorization)
                response = await send(path: path, method: method, body: body, token: renewed.token)
                try Task.checkCancellation()
                try await sessionManager.validateSession(renewed)
                if response.response?.statusCode == 401 {
                    try await sessionManager.expire(ifMatching: renewed)
                    throw SessionError.expired
                }
            }
        }
        return try decodeEnvelope(response)
    }

    private func send<Body: Encodable>(
        path: String, method: HTTPMethod, body: Body?, token: String?
    ) async -> AFDataResponse<Data> {
        let headers: HTTPHeaders = token.map { [.authorization(bearerToken: $0)] } ?? []
        return await session.request(
            baseURL.appendingPathComponent(path),
            method: method,
            parameters: body,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).serializingData().response
    }

    private func decodeEnvelope<Response: Decodable>(
        _ response: AFDataResponse<Data>
    ) throws -> APIEnvelope<Response> {
        let data: Data
        do {
            data = try response.result.get()
        } catch {
            throw NetworkError.underlying(error)
        }
        guard let status = response.response?.statusCode, (200..<300).contains(status) else {
            let message = (try? JSONDecoder().decode(APIErrorResponse.self, from: data))?.message
            throw NetworkError.server(message: message ?? "Terjadi kesalahan pada server.")
        }
        do {
            return try JSONDecoder().decode(APIEnvelope<Response>.self, from: data)
        } catch {
            throw NetworkError.decodingMismatch(underlying: error)
        }
    }
}

private struct EmptyPayload: Decodable {}
private struct EmptyBody: Encodable {}
