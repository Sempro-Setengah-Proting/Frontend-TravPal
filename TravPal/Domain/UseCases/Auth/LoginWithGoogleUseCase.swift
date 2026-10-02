//
//  Login.swift
//  TravPal
//
//  Created by Revan Arturito on 23/09/26.
//

protocol LoginWithGoogleUseCaseProtocol {
    func execute(idToken: String, deviceId: String) async throws -> GoogleAuthSessionModel
}

final class LoginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(idToken: String, deviceId: String) async throws -> GoogleAuthSessionModel {
        return try await repository.loginWithGoogle(idToken: idToken, deviceID: deviceId)
    }
}
