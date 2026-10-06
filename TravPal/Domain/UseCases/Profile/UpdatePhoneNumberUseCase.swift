//
//  UpdatePhoneNumberUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

protocol UpdatePhoneNumberUseCaseProtocol {
    func execute(phone: String) async throws -> UserProfileModel
}

final class UpdatePhoneNumberUseCase: UpdatePhoneNumberUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(phone: String) async throws -> UserProfileModel {
        let trimmed = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        return try await repository.updatePhone(phone: trimmed)
    }
}
