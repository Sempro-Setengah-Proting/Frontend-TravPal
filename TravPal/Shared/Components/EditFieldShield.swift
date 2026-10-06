//
//  EditFieldShield.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//


import SwiftUI

struct EditFieldSheet<Field: View>: View {
    let title: String
    let isLoading: Bool
    let canSave: Bool
    let errorMessage: String?
    let onSave: () -> Void
    @ViewBuilder var field: Field

    @Environment(\.dismiss) private var dismiss
    @State private var showToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VSpace(.appSpacingV20)
                    field
                    Spacer()
                }
                .padding(.appSpacingH20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                .sharedBackgroundVisibility(.hidden)

                ToolbarItem(placement: .topBarTrailing) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Save", action: onSave)
                            .foregroundStyle(Color.appPrimary)
                            .opacity(canSave ? 1 : 0.4)
                            .disabled(!canSave)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        .interactiveDismissDisabled(isLoading)
        .dynamicIslandToast(
            isPresented: $showToast,
            title: toastMessage,
            systemImage: "xmark.circle.fill",
            tintColor: .appDanger
        )
        .onChange(of: errorMessage) { _, newValue in
            guard let newValue else { return }
            toastMessage = newValue
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showToast = true
            }
        }
    }
}
