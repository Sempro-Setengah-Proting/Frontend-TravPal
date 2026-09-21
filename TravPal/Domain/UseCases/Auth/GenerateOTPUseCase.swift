//
//  GenerateOTPUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

protocol GenerateOTPUseCaseProtocol {
    func execute(email: String) async throws
}

final class GenerateOTPUseCase: GenerateOTPUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String) async throws {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try await repository.generateOTP(email: trimmedEmail)
    }
}
