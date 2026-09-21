//
//  LoginUseCase.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthSession
}
