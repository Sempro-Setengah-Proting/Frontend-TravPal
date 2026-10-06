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
    func loginWithGoogle(_ request: GoogleLoginRequestDTO) async throws -> AuthSessionDTO
}

final class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol) {
        self.client = client
    }
    
    func login(_ request: LoginRequestDTO) async throws -> AuthSessionDTO {
        try await client.perform(path: "auth/sign-in", body: request, decode: AuthSessionDTO.self)
    }
    
    func register(_ request: RegisterRequestDTO) async throws -> RegisterResponseDTO {
        try await client.perform(path: "auth/sign-up", body: request, decode: RegisterResponseDTO.self)
    }
    
    func generateOTP(_ request: GenerateOTPRequestDTO) async throws -> Void {
        try await client.performWithoutPayload(path: "auth/register/otp/request", body: request)
    }
    
    func verifyOTP(_ request: VerifyOTPRequestDTO) async throws -> VerifyOTPResponseDTO {
        try await client.perform(path: "auth/register/otp/verify", body: request, decode: VerifyOTPResponseDTO.self)
    }
    
    func loginWithGoogle(_ request: GoogleLoginRequestDTO) async throws -> AuthSessionDTO {
        try await client.perform(path: "oauth/sign-in-google", body: request, decode: AuthSessionDTO.self)
    }
}

private struct EmptyPayload: Decodable {}
