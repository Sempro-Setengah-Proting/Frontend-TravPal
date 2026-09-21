//
//  VerifyOTPView.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//


import SwiftUI

struct VerifyOTPView: View {
    @StateObject private var viewModel: VerifyOTPViewModel

    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    init(pendingRegistration: PendingRegistrationModel) {
        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.resolve(
                VerifyOTPViewModel.self,
                argument: pendingRegistration
            )
        )
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Verify your email")
                    .font(.appBold32)
                VSpace(.appSpacingV8)
                Text("We sent a code to \(viewModel.email)")
                    .font(.appRegular14)
                VSpace(.appSpacingV40)

                CustomTextField(title: "OTP Code", placeholder: "123456", text: $viewModel.otp)
                    .keyboardType(.numberPad)

                VSpace(.appSpacingV40)
                CustomAuthButton(
                    title: "Verify",
                    isLoading: viewModel.isLoading,
                    isEnabled: viewModel.isOTPValid
                ) {
                    Task { await viewModel.verify() }
                }

                VSpace(.appSpacingV20)
                Button {
                    Task { await viewModel.resendOTP() }
                } label: {
                    Text(viewModel.isResending ? "Resending..." : "Didn't get a code? Resend")
                        .font(.appSemiBold12)
                        .foregroundColor(.appPrimary)
                }
                .disabled(viewModel.isResending)

                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.didCompleteRegistration) {
            LoginView()
        }
        .dynamicIslandToast(
            isPresented: $showToast,
            title: toastMessage,
            systemImage: "xmark.circle.fill",
            tintColor: .appDanger
        )
        .onChange(of: viewModel.errorMessage) { _, newValue in
            guard let message = newValue else { return }
            toastMessage = message
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showToast = true
            }
        }
    }
}
