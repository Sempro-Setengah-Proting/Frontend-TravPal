//
//  RegisterViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var phoneNumber = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    @Published private(set) var pendingRegistration: PendingRegistrationModel?
    @Published var didRequestOTP = false
    
    private let generateOTPUseCase: GenerateOTPUseCaseProtocol
    
    init(generateOTPUseCase: GenerateOTPUseCaseProtocol) {
        self.generateOTPUseCase = generateOTPUseCase
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
}

