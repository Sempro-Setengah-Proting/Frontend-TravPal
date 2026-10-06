//
//  EditEmailViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Combine

@MainActor
final class EditEmailViewModel: ObservableObject {
    @Published var email: String
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let initialEmail: String
    private let updateEmailUseCase: UpdateEmailUseCaseProtocol

    init(email: String, updateEmailUseCase: UpdateEmailUseCaseProtocol) {
        self.email = email
        self.initialEmail = email
        self.updateEmailUseCase = updateEmailUseCase
    }

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isEmailValid: Bool {
        EmailValidator.isValid(trimmedEmail)
    }

    var emailErrorMessage: String? {
        !trimmedEmail.isEmpty && !isEmailValid ? EmailValidator.errorMessage : nil
    }

    var canSave: Bool {
        isEmailValid && trimmedEmail.lowercased() != initialEmail.lowercased()
    }

    func save() async -> UserProfileModel? {
        guard canSave, !isLoading else { return nil }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            return try await updateEmailUseCase.execute(email: email)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
