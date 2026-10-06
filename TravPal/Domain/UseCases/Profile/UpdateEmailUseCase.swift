//
//  UpdateEmailUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

protocol UpdateEmailUseCaseProtocol {
    func execute(email: String) async throws -> UserProfileModel
}

final class UpdateEmailUseCase: UpdateEmailUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String) async throws -> UserProfileModel {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return try await repository.updateEmail(email: trimmed)
    }
}
