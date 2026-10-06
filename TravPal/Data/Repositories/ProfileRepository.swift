//
//  ProfileRepository.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol
    
    init(remoteDataSource: ProfileRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getProfile() async throws -> UserProfileModel {
        try await mapped {
            let dto = try await remoteDataSource.getProfile()
            return dto.toDomain()
        }
    }
    
    func updateName(name: String) async throws -> UserProfileModel {
        try await mapped {
            let dto = try await remoteDataSource.updateName(
                UpdateNameRequestDTO(name: name)
            )
            return dto.toDomain()
        }
    }
    
    func updateEmail(email: String) async throws -> UserProfileModel {
        try await mapped {
            let dto = try await remoteDataSource.updateEmail(
                UpdateEmailRequestDTO(email: email)
            )
            return dto.toDomain()
        }
    }
    
    func updatePhone(phone: String) async throws -> UserProfileModel {
        try await mapped {
            let dto = try await remoteDataSource.updatePhone(
                UpdatePhoneRequestDTO(phone: phone)
            )
            return dto.toDomain()
        }
    }
    
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
