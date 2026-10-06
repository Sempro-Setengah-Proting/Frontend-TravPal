//
//  APIClient.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Alamofire

protocol APIClientProtocol {
    /// Request dengan body, mengembalikan data.
    func perform<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod, body: Body, decode: Response.Type
    ) async throws -> Response

    /// Request tanpa body (misalnya GET), mengembalikan data.
    func perform<Response: Decodable>(
        path: String, method: HTTPMethod, decode: Response.Type
    ) async throws -> Response

    /// Request dengan body, tanpa data di response.
    func performWithoutPayload<Body: Encodable>(
        path: String, method: HTTPMethod, body: Body
    ) async throws
}

/// Default POST supaya kode Auth yang lama tidak perlu menulis `method:`.
extension APIClientProtocol {
    func perform<Body: Encodable, Response: Decodable>(
        path: String, body: Body, decode: Response.Type
    ) async throws -> Response {
        try await perform(path: path, method: .post, body: body, decode: decode)
    }

    func performWithoutPayload<Body: Encodable>(path: String, body: Body) async throws {
        try await performWithoutPayload(path: path, method: .post, body: body)
    }
}

final class APIClient: APIClientProtocol {
    private let session: Session
    private let baseURL: URL

    init(session: Session, baseURL: URL = Constants.apiBaseURL) {
        self.session = session
        self.baseURL = baseURL
    }

    // MARK: Public

    func perform<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod, body: Body, decode: Response.Type
    ) async throws -> Response {
        let envelope = try await requestEnvelope(path: path, method: method, body: body, decode: Response.self)
        return try unwrap(envelope)
    }

    func perform<Response: Decodable>(
        path: String, method: HTTPMethod, decode: Response.Type
    ) async throws -> Response {
        let envelope = try await requestEnvelope(
            path: path, method: method, body: Optional<EmptyBody>.none, decode: Response.self
        )
        return try unwrap(envelope)
    }

    func performWithoutPayload<Body: Encodable>(
        path: String, method: HTTPMethod, body: Body
    ) async throws {
        let envelope = try await requestEnvelope(path: path, method: method, body: body, decode: EmptyPayload.self)
        guard envelope.isSuccess else {
            throw NetworkError.server(message: envelope.message ?? "Terjadi kesalahan, coba lagi ya.")
        }
    }

    // MARK: Private

    private func unwrap<T>(_ envelope: APIEnvelope<T>) throws -> T {
        guard envelope.isSuccess else {
            throw NetworkError.server(message: envelope.message ?? "Terjadi kesalahan, coba lagi ya.")
        }
        guard let data = envelope.data else {
            throw NetworkError.decodingMismatch(underlying: NetworkError.invalidResponse)
        }
        return data
    }

    private func requestEnvelope<Body: Encodable, Response: Decodable>(
        path: String, method: HTTPMethod, body: Body?, decode: Response.Type
    ) async throws -> APIEnvelope<Response> {
        let url = baseURL.appendingPathComponent(path)

        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: body,
                encoder: JSONParameterEncoder.default
            )
            .responseDecodable(of: APIEnvelope<Response>.self) { response in
                #if DEBUG
                print("[\(path)] status: \(response.response?.statusCode ?? -1)")
                if let data = response.data, let text = String(data: data, encoding: .utf8) {
                    print("[\(path)] body: \(text)")
                }
                #endif

                switch response.result {
                case .success(let envelope):
                    continuation.resume(returning: envelope)
                case .failure(let error):
                    if let data = response.data,
                       let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        continuation.resume(throwing: NetworkError.server(message: apiError.message))
                    } else {
                        continuation.resume(throwing: NetworkError.underlying(error))
                    }
                }
            }
        }
    }
}

private struct EmptyPayload: Decodable {}
private struct EmptyBody: Encodable {}
