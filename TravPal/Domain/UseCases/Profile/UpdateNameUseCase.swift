//
//  UpdateNameUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

protocol UpdateNameUseCaseProtocol {
    func execute(name: String) async throws -> UserProfileModel
}

final class UpdateNameUseCase: UpdateNameUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String) async throws -> UserProfileModel {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return try await repository.updateName(name: trimmed)
    }
}
