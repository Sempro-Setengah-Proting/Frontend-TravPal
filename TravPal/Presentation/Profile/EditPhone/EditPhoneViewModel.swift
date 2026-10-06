//
//  EditPhoneViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Combine

@MainActor
final class EditPhoneViewModel: ObservableObject {
    @Published var phoneNumber: String
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let initialPhoneNumber: String
    private let updatePhoneNumberUseCase: UpdatePhoneNumberUseCaseProtocol

    init(phoneNumber: String, updatePhoneNumberUseCase: UpdatePhoneNumberUseCaseProtocol) {
        self.phoneNumber = phoneNumber
        self.initialPhoneNumber = phoneNumber
        self.updatePhoneNumberUseCase = updatePhoneNumberUseCase
    }

    private var trimmedPhoneNumber: String {
        phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isPhoneNumberValid: Bool {
        PhoneNumberValidator.isValid(trimmedPhoneNumber)
    }

    var phoneNumberErrorMessage: String? {
        !trimmedPhoneNumber.isEmpty && !isPhoneNumberValid ? PhoneNumberValidator.errorMessage : nil
    }

    var canSave: Bool {
        isPhoneNumberValid && trimmedPhoneNumber != initialPhoneNumber
    }

    func save() async -> UserProfileModel? {
        guard canSave, !isLoading else { return nil }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            return try await updatePhoneNumberUseCase.execute(phone: phoneNumber)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
