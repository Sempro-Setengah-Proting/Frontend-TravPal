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
        try await mapped {
            let dto = try await remoteDataSource.login(
                LoginRequestDTO(
                    email: email,
                    password: password
                )
            )
            return dto.toDomain()
        }
    }
    
    func register(email: String, password: String, phoneNumber: String, name: String, deviceId: String, registrationToken: String) async throws {
        try await mapped {
            _ = try await remoteDataSource.register(
                RegisterRequestDTO(
                    email: email,
                    password: password,
                    phone_number: phoneNumber,
                    device_id: deviceId,
                    name: name,
                    registration_token: registrationToken
                )
            )
        }
    }
    func verifyOTP(email: String, otp: String) async throws -> String {
        try await mapped {
            let dto = try await remoteDataSource.verifyOTP(
                VerifyOTPRequestDTO(
                    email: email,
                    otp: otp
                )
            )
            return dto.registrationToken
        }
    }
    
    func generateOTP(email: String) async throws {
        try await mapped {
            _ = try await remoteDataSource.generateOTP(
                GenerateOTPRequestDTO(
                    email: email
                )
            )
        }
    }
    
    func loginWithGoogle(idToken: String, deviceID: String) async throws -> AuthSessionModel {
        try await mapped {
            let dto = try await remoteDataSource.loginWithGoogle(
                GoogleLoginRequestDTO(
                    id_token: idToken,
                    device_id: deviceID
                )
            )
            return dto.toDomain()
        }
    }
    
    // MARK: Error mapping
    
    private func mapped<T>(_ operation: () async throws -> T) async throws -> T {
        do {
            return try await operation()
        } catch let error as NetworkError {
            if case .server(let message) = error {
                throw AuthError.map(from: message)
            }
            throw error
        }
    }
}


