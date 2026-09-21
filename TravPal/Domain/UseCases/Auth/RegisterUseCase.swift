//
//  RegisterUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

protocol RegisterUseCaseProtocol {
    func execute(email: String, password: String, phone_number: String, username: String) async throws
}

final class RegisterUseCase: RegisterUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String, phone_number: String, username: String) async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        try await repository.Register(email: trimmedEmail, password: password, phone_number: phone_number, username: trimmedUsername)
    }
}
