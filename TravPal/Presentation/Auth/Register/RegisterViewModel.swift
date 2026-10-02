//
//  RegisterViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation
import Combine
import UIKit
import GoogleSignIn

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var phoneNumber = ""
    @Published private(set) var isLoading = false
    @Published private(set) var isGoogleLoading = false
    @Published var errorMessage: String?
    @Published private(set) var googleSession: AuthSessionModel?
    
    @Published private(set) var pendingRegistration: PendingRegistrationModel?
    @Published var didRequestOTP = false
    
    private let generateOTPUseCase: GenerateOTPUseCaseProtocol
    private let loginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol
    
    init(
        generateOTPUseCase: GenerateOTPUseCaseProtocol,
        loginWithGoogleUseCase: LoginWithGoogleUseCaseProtocol
    ) {
        self.generateOTPUseCase = generateOTPUseCase
        self.loginWithGoogleUseCase = loginWithGoogleUseCase
    }
    
    var isFormValid: Bool {
        !username.isEmpty && !email.isEmpty && !password.isEmpty && !phoneNumber.isEmpty
    }
    
    var isEmailValid: Bool {
        EmailValidator.isValid(email)
    }
    
    var isPasswordValid: Bool {
        PasswordValidator.isValid(password)
    }
    
    var isPhoneNumberValid: Bool {
        PhoneNumberValidator.isValid(phoneNumber)
    }
    
    var emailErrorMessage: String? {
        !email.isEmpty && !isEmailValid ? EmailValidator.errorMessage : nil
    }
    
    var passwordErrorMessage: String? {
        !password.isEmpty && !isPasswordValid ? PasswordValidator.errorMessage : nil
    }
    
    var phoneNumberErrorMessage: String? {
        !phoneNumber.isEmpty && !isPhoneNumberValid ? PhoneNumberValidator.errorMessage : nil
    }
    
    func requestOTP() async {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await generateOTPUseCase.execute(email: email)
            pendingRegistration = PendingRegistrationModel(
                name: username,
                email: email,
                password: password,
                phoneNumber: phoneNumber,
                deviceId: DeviceIdentifier.current
            )
            didRequestOTP = true
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
            googleSession = try await loginWithGoogleUseCase.execute(
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

