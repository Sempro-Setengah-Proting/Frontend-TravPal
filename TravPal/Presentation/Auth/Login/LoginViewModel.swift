//
//  LoginViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var session: AuthSessionModel?

    private let loginUseCase: LoginUseCaseProtocol

    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }

    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func login() async {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            session = try await loginUseCase.execute(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
