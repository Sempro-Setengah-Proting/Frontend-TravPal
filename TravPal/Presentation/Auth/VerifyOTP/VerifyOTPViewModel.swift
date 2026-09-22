//
//  VerifyViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation
import Combine

@MainActor
final class VerifyOTPViewModel: ObservableObject {
    @Published var otp = ""
    @Published private(set) var isLoading = false
    @Published private(set) var isResending = false
    @Published var errorMessage: String?
    @Published var didCompleteRegistration = false

    let email: String

    private let pendingRegistration: PendingRegistrationModel
    private let verifyOTPUseCase: VerifyOTPUseCaseProtocol
    private let registerUseCase: RegisterUseCaseProtocol
    private let generateOTPUseCase: GenerateOTPUseCaseProtocol

    init(
        pendingRegistration: PendingRegistrationModel,
        verifyOTPUseCase: VerifyOTPUseCaseProtocol,
        registerUseCase: RegisterUseCaseProtocol,
        generateOTPUseCase: GenerateOTPUseCaseProtocol
    ) {
        self.pendingRegistration = pendingRegistration
        self.email = pendingRegistration.email
        self.verifyOTPUseCase = verifyOTPUseCase
        self.registerUseCase = registerUseCase
        self.generateOTPUseCase = generateOTPUseCase
    }

    var isOTPValid: Bool {
        !otp.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func verify() async {
        guard isOTPValid else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let registrationToken = try await verifyOTPUseCase.execute(email: email, otp: otp)
            try await registerUseCase.execute(
                email: pendingRegistration.email,
                password: pendingRegistration.password,
                phoneNumber: pendingRegistration.phoneNumber,
                name: pendingRegistration.name,
                deviceId: pendingRegistration.deviceId,
                registrationToken: registrationToken
            )
            didCompleteRegistration = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func resendOTP() async {
        isResending = true
        errorMessage = nil
        successMessage = nil
        defer { isResending = false }

        do {
            try await generateOTPUseCase.execute(email: email)
            successMessage = "Kode OTP baru telah dikirim ke email."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
