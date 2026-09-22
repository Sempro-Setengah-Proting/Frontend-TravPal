//
//  RegisterView.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    init(viewModel: RegisterViewModel = DIContainer.shared.resolve(RegisterViewModel.self)) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Image("ic_travpal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 50)
                    Text("TravPal")
                        .font(.appBold32)
                    Text("Create your account")
                        .font(.appRegular14)
                    VSpace(.appSpacingV40)
                    
                    CustomTextField(title: "Username", placeholder: "hafid open bo", text: $viewModel.username)
                    VSpace(.appSpacingV12)
                    CustomTextField(title: "Email", placeholder: "travpal@gmail.com", text: $viewModel.email, isValid: viewModel.isEmailValid, errorMessage: viewModel.emailErrorMessage)
                    VSpace(.appSpacingV12)
                    CustomTextField(title: "Phone Number", placeholder: "0812345678", text: $viewModel.phoneNumber, isValid: viewModel.isPhoneNumberValid, errorMessage: viewModel.phoneNumberErrorMessage)
                    VSpace(.appSpacingV12)
                    CustomSecureField(title: "Password", placeholder: "travpal@gmail.com", text: $viewModel.password, isValid: viewModel.isPasswordValid, errorMessage: viewModel.passwordErrorMessage)
                    
                    VSpace(.appSpacingV40)
                    CustomAuthButton(
                        title: "Sign Up",
                        isLoading: viewModel.isLoading,
                        isEnabled: viewModel.isFormValid
                    ) {
                        Task { await viewModel.requestOTP() }
                    }
                    
                    
                    VSpace(.appSpacingV20)
                    HStack {
                        VStack { Divider() }
                        
                        HSpace(.appSpacingH12)
                        
                        Text("Or log in with")
                            .font(.appRegular12)
                            .foregroundColor(.appTextSecondary)
                        
                        HSpace(.appSpacingH12)
                        
                        VStack { Divider() }
                    }
                    VSpace(.appSpacingV20)
                    
                    HStack(spacing: .appSpacingH20) {
                        SocialLoginButton(
                            title: "Google",
                            iconName: "ic_google",
                            isSystemIcon: false
                        ) {
                            print("Google login pressed")
                        }
                        
                        SocialLoginButton(
                            title: "Apple",
                            iconName: "apple.logo",
                            isSystemIcon: true
                        ) {
                            print("Apple login pressed")
                        }
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.appRegular12)
                            .foregroundColor(.appTextSecondary)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Log in")
                                .font(.appSemiBold12)
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.didRequestOTP) {
                if let pendingRegistration = viewModel.pendingRegistration {
                    VerifyOTPView(pendingRegistration: pendingRegistration)
                }
            }
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

#Preview {
    RegisterView()
}

