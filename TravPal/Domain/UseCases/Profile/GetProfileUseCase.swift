//
//  GetProfileUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

protocol GetProfileUseCaseProtocol {
    func execute() async throws -> UserProfileModel
}

final class GetProfileUseCase: GetProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfileModel {
        try await repository.getProfile()
    }
}
