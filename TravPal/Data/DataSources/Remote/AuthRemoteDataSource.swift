//
//  AuthRemoteDataSource.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation
import Alamofire

protocol AuthRemoteDataSourceProtocol {
    func login(_ request: LoginRequestDTO) async throws -> AuthSessionDTO
    func register(_ request: RegisterRequestDTO) async throws -> RegisterResponseDTO
    func generateOTP(_ request: GenerateOTPRequestDTO) async throws -> Void
    func verifyOTP(_ request: VerifyOTPRequestDTO) async throws -> VerifyOTPResponseDTO
}

final class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let session: Session
    private let baseURL: URL
    
    init(session: Session, baseURL: URL = Constants.apiBaseURL) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func login(_ request: LoginRequestDTO) async throws -> AuthSessionDTO {
        try await perform(path: "auth/sign-in", body: request, decode: AuthSessionDTO.self)
    }
    
    func register(_ request: RegisterRequestDTO) async throws -> RegisterResponseDTO {
        try await perform(path: "auth/sign-up", body: request, decode: RegisterResponseDTO.self)
    }
    
    func generateOTP(_ request: GenerateOTPRequestDTO) async throws -> Void {
        try await performWithoutPayload(path: "auth/register/otp/request", body: request)
    }
    
    func verifyOTP(_ request: VerifyOTPRequestDTO) async throws -> VerifyOTPResponseDTO {
        try await perform(path: "auth/register/otp/verify", body: request, decode: VerifyOTPResponseDTO.self)
    }
    
    // MARK: Helpers
    
    private func perform<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body,
        decode: Response.Type
    ) async throws -> Response {
        let envelope = try await requestEnvelope(path: path, body: body, decode: Response.self)
        
        guard envelope.isSuccess else {
            throw NetworkError.server(message: envelope.message ?? "Terjadi kesalahan, coba lagi ya.")
        }
        guard let data = envelope.data else {
            throw NetworkError.decodingMismatch(underlying: NetworkError.invalidResponse)
        }
        return data
    }
    
    private func performWithoutPayload<Body: Encodable>(
        path: String,
        body: Body
    ) async throws {
        let envelope = try await requestEnvelope(path: path, body: body, decode: EmptyPayload.self)
        
        guard envelope.isSuccess else {
            throw NetworkError.server(message: envelope.message ?? "Terjadi kesalahan, coba lagi ya.")
        }
    }
    
    private func requestEnvelope<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body,
        decode: Response.Type
    ) async throws -> APIEnvelope<Response> {
        let url = baseURL.appendingPathComponent(path)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: .post,
                parameters: body,
                encoder: JSONParameterEncoder.default
            )
            .responseDecodable(of: APIEnvelope<Response>.self) { response in
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
