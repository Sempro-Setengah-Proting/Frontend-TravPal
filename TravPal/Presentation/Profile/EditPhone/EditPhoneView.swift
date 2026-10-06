//
//  EditPhoneView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct EditPhoneView: View {
    @StateObject private var viewModel: EditPhoneViewModel
    @Environment(\.dismiss) private var dismiss
    let onSaved: (UserProfileModel) -> Void

    init(phoneNumber: String, onSaved: @escaping (UserProfileModel) -> Void) {
        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.resolve(EditPhoneViewModel.self, argument: phoneNumber)
        )
        self.onSaved = onSaved
    }

    var body: some View {
        EditFieldSheet(
            title: "Phone Number",
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
                title: "Phone Number",
                placeholder: "08123456789",
                text: $viewModel.phoneNumber,
                isValid: viewModel.isPhoneNumberValid,
                errorMessage: viewModel.phoneNumberErrorMessage,
            )
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    EditPhoneView(phoneNumber: "08123456789") { _ in }
}
