//
//  Button.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//

import SwiftUI

struct CustomAuthButton: View {
    let title: String
    var isLoading: Bool = false
    var isEnabled: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .frame(height: 52)
            .background(isEnabled ? Color.appPrimary : Color.gray.opacity(0.4))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
        .disabled(!isEnabled || isLoading)
    }
}


struct SocialLoginButton: View {
    let title: String
    let iconName: String
    let isSystemIcon: Bool
    var isLoading: Bool = false
    let action: () -> Void
    
    init(
        title: String,
        iconName: String,
        isSystemIcon: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.isSystemIcon = isSystemIcon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: .appSpacingH10) {
                if isLoading {
                    ProgressView()
                        .tint(.appTextPrimary)
                } else {
                    if isSystemIcon {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.appTextPrimary)
                    } else {
                        Image(iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text(title)
                        .font(.appMedium16)
                        .foregroundColor(.appTextPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        }
        .disabled(isLoading)
    }
}
