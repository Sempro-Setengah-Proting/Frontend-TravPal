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
            LoginRequestDTO(
                email: email,
                password: password
            )
        )
        return dto.toDomain()
    }
    
    func register(email: String, password: String, phoneNumber: String, name: String, deviceId: String, registrationToken: String) async throws {
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
    func verifyOTP(email: String, otp: String) async throws -> String {
            let dto = try await remoteDataSource.verifyOTP(
                VerifyOTPRequestDTO(
                    email: email,
                    otp: otp
                )
            )
        return dto.registrationToken
    }
    
    func generateOTP(email: String) async throws {
        _ = try await remoteDataSource.generateOTP(
            GenerateOTPRequestDTO(
                email: email
            )
        )
    }
}
