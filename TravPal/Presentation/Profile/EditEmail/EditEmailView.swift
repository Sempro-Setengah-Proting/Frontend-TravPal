//
//  EditEmailView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct EditEmailView: View {
    @StateObject private var viewModel: EditEmailViewModel
    @Environment(\.dismiss) private var dismiss
    let onSaved: (UserProfileModel) -> Void

    init(email: String, onSaved: @escaping (UserProfileModel) -> Void) {
        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.resolve(EditEmailViewModel.self, argument: email)
        )
        self.onSaved = onSaved
    }

    var body: some View {
        EditFieldSheet(
            title: "Email",
            isLoading: viewModel.isLoading,
            canSave: viewModel.canSave,
            errorMessage: viewModel.errorMessage,
            onSave: {
                Task {
                    if let profile = await viewModel.save() {
                        onSaved(profile)
                        dismiss()
                    }
                }
            }
        ) {
            CustomTextField(
                title: "Email",
                placeholder: "travpal@gmail.com",
                text: $viewModel.email,
                isValid: viewModel.isEmailValid,
                errorMessage: viewModel.emailErrorMessage,
            )
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    EditEmailView(email: "revan@mail.com") { _ in }
}
