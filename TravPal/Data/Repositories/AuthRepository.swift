//
//  AuthRepository.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    
    init(remoteDataSource: AuthRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func login(email: String, password: String) async throws -> AuthSessionModel {
        let dto = try await remoteDataSource.login(
            LoginRequestDTO(email: email, password: password)
        )
        return dto.toDomain()
    }
    
    func Register(email: String, password: String, phone_number: String, username: String) async throws {
        _ = try await remoteDataSource.register(
            RegisterRequestDTO(email: email, password: password, phone_number: phone_number, username: username)
        )
    }
    
    func verifyOTP(email: String, otp: String) async throws -> AuthSessionModel {
        let dto = try await remoteDataSource.verifyOTP(
            VerifyOTPRequestDTO(email: email, otp: otp)
        )
        return dto.toDomain()
    }
    
    func generateOTP(email: String) async throws {
        _ = try await remoteDataSource.generateOTP(
            GenerateOTPRequestDTO(email: email)
        )
    }
}
