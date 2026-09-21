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
    func generateOTP(_ request: GenerateOTPRequestDTO) async throws -> GenerateOTPResponseDTO
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
    
    func generateOTP(_ request: GenerateOTPRequestDTO) async throws -> GenerateOTPResponseDTO {
        try await perform(path: "auth/register/otp/request", body: request, decode: GenerateOTPResponseDTO.self)
    }
    
    func verifyOTP(_ request: VerifyOTPRequestDTO) async throws -> VerifyOTPResponseDTO {
        try await perform(path: "auth/verify", body: request, decode: VerifyOTPResponseDTO.self)
    }
    
    private func perform<Body: Encodable, Response: Decodable>(
        path: String,
        body: Body,
        decode: Response.Type
    ) async throws -> Response {
        let url = baseURL.appendingPathComponent(path)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: .post,
                parameters: body,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: APIResponse<Response>.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    continuation.resume(returning: apiResponse.data)
                    
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
