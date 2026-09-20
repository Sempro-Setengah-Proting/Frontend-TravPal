//
//  LoginView.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//

import SwiftUI

struct LoginView: View {
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var isLoading: Bool = false
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var toastIcon: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                VStack {
                    // MARK: TITLE AND SUBTITLE
                    Spacer()
                    Text("TravPal")
                        .font(.appBold32)
                    VSpace(.appSpacingV8)
                    Text("Welcome back pal, please log in")
                        .font(.appRegular14)
                    VSpace(.appSpacingV40)
                    
                    // MARK: FORM
                    CustomTextField(title: "Email", placeholder: "travpal@gmail.com", text: $emailText)
                    VSpace(.appSpacingV12)
                    CustomSecureField(title: "Password", placeholder: "travpal@gmail.com", text: $passwordText)
                    
                    VSpace(.appSpacingV40)
                    CustomAuthButton(
                        title: "Lanjut",
                        isLoading: isLoading,
                        isEnabled: !emailText.isEmpty && !passwordText.isEmpty,
                    ) {
                        print("Button diklik, email: \(emailText)")
                    }
                    
                    
                    // MARK: SOCIAL LOGIN
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
                            toastMessage = "Login dengan Google berhasil!"
                            toastIcon = "checkmark.circle.fill"
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showToast = true
                            }                        }
                        
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
                        Text("Don't have an account?")
                            .font(.appRegular12)
                            .foregroundColor(.appTextSecondary)
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign up")
                                .font(.appSemiBold12)
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
        }
        .dynamicIslandToast(
            isPresented: $showToast,
            title: toastMessage,
            systemImage: toastIcon,
            tintColor: .appSuccess
        )
    }
}

#Preview {
    LoginView()
}
