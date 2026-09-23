//
//  LoginViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation
import Combine
import UIKit
import GoogleSignIn

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published private(set) var isGoogleLoading = false
    @Published var errorMessage: String?
    @Published private(set) var session: AuthSessionModel?

    private let loginUseCase: LoginUseCaseProtocol
    private let loginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol

    init(
        loginUseCase: LoginUseCaseProtocol,
        loginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol
    ) {
        self.loginUseCase = loginUseCase
        self.loginWithGoogleUseCase = loginWithGoogleUseCase
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

    func loginWithGoogle() async {
        guard let presentingVC = UIApplication.shared.rootViewController else {
            errorMessage = "Terjadi kesalahan, coba lagi ya."
            return
        }

        isGoogleLoading = true
        errorMessage = nil
        defer { isGoogleLoading = false }

        do {
            let idToken = try await signInWithGoogleSDK(presenting: presentingVC)
            session = try await loginWithGoogleUseCase.execute(
                idToken: idToken,
                deviceId: DeviceIdentifier.current
            )
        } catch is CancellationError {
            // User nutup sheet Google sign-in sendiri, gak perlu toast error.
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func signInWithGoogleSDK(presenting viewController: UIViewController) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
                if let error {
                    if (error as NSError).code == -5 {
                        continuation.resume(throwing: CancellationError())
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                guard let idToken = result?.user.idToken?.tokenString else {
                    continuation.resume(throwing: NetworkError.invalidResponse)
                    return
                }
                continuation.resume(returning: idToken)
            }
        }
    }
}
