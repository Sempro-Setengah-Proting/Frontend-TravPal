//
//  ProfileRemoteDataSource.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Alamofire

protocol ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> ProfileDTO
    func updateName(_ request: UpdateNameRequestDTO) async throws -> ProfileDTO
    func updateEmail(_ request: UpdateEmailRequestDTO) async throws -> ProfileDTO
    func updatePhone(_ request: UpdatePhoneRequestDTO) async throws -> ProfileDTO
}

final class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    private let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func getProfile() async throws -> ProfileDTO {
        try await client.perform(path: "users/me", method: .get, decode: ProfileDTO.self, requiresAuth: true)
    }

    func updateName(_ request: UpdateNameRequestDTO) async throws -> ProfileDTO {
        try await client.perform(path: "users/me", method: .patch, body: request, decode: ProfileDTO.self, requiresAuth: true)
    }
    
    func updateEmail(_ request: UpdateEmailRequestDTO) async throws -> ProfileDTO {
        try await client.perform(path: "users/me", method: .patch, body: request, decode: ProfileDTO.self, requiresAuth: true)
    }
    
    func updatePhone(_ request: UpdatePhoneRequestDTO) async throws -> ProfileDTO {
        try await client.perform(path: "users/me", method: .patch, body: request, decode: ProfileDTO.self, requiresAuth: true)
    }
}

private struct EmptyPayload: Decodable {}
