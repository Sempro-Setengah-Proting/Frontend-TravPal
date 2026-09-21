//
//  VerifyOTPUsecase.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

protocol VerifyOTPUseCaseProtocol {
    func execute(email: String, otp: String) async throws -> AuthSessionModel
}

final class VerifyOTPUseCase: VerifyOTPUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, otp: String) async throws -> AuthSessionModel {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return try await repository.verifyOTP(email: trimmedEmail, otp: otp)
    }
}
