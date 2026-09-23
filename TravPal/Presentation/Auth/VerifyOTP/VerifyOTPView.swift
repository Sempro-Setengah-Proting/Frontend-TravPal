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
    @State private var activeToast: ToastState?
    
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
                Text("Enter 6 digit code that you’ll receive on your email")
                Text("\(viewModel.email)")
                    .font(.appRegular14)
                VSpace(.appSpacingV40)
                
                OTPField(code: $viewModel.otp, length: 6) { _ in
                    Task { await viewModel.verify() }
                }
                
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
            title: activeToast?.message ?? "",
            systemImage: activeToast?.systemImage ?? "xmark.circle.fill",
            tintColor: activeToast?.tintColor ?? .appDanger
        )
        .onChange(of: viewModel.toast) { _, newValue in
            guard let toast = newValue else { return }
            activeToast = toast
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showToast = true
            }
        }
    }
}
