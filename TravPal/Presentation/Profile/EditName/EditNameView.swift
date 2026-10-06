//
//  EditNameView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI
 
struct EditNameView: View {
    @StateObject private var viewModel: EditNameViewModel
    @Environment(\.dismiss) private var dismiss
    let onSaved: (UserProfileModel) -> Void
 
    init(name: String, onSaved: @escaping (UserProfileModel) -> Void) {
        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.resolve(EditNameViewModel.self, argument: name)
        )
        self.onSaved = onSaved
    }
 
    var body: some View {
        EditFieldSheet(
            title: "Name",
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
                title: "Name",
                placeholder: "Your name",
                text: $viewModel.name
            )
        }
        .presentationDetents([.medium])
    }
}
 
#Preview {
    EditNameView(name: "Revan Arturito") { _ in }
}
