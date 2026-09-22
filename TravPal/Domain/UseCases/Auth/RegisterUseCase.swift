//
//  RegisterUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func execute(email: String, password: String, phoneNumber: String, name: String, deviceId: String, registrationToken: String) async throws
}

final class RegisterUseCase: RegisterUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String, phoneNumber: String, name: String, deviceId: String, registrationToken: String) async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        try await repository.register(
            email: trimmedEmail,
            password: password,
            phoneNumber: phoneNumber,
            name: trimmedName,
            deviceId: deviceId,
            registrationToken: registrationToken
        )
    }
}

