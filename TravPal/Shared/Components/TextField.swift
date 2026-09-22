//
//  TextField.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//

import SwiftUI

struct CustomTextField: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    var isValid: Bool = true
    var errorMessage: String? = nil
    
    @FocusState var isFocused: Bool
    @State private var shakeAmount: CGFloat = 0
    
    private var activeColor: Color {
        if !text.isEmpty && !isValid {
            return Color.appDanger
        } else if isFocused || !text.isEmpty {
            return Color.appPrimary
        } else {
            return Color.appBorder
        }
    }
    
    private var lineWidth: CGFloat {
        if isFocused {
            return 2.0
        } else if !text.isEmpty {
            return 1.5
        } else {
            return 1.0
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(activeColor)
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.appPrimary.opacity(isFocused ? 0.06 : 0))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(activeColor, lineWidth: lineWidth)
                )
                .keyboardType(.default)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .scaleEffect(isFocused ? 1.015 : 1.0)
                .modifier(ShakeEffect(animatableData: shakeAmount))
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundStyle(Color.appDanger)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: activeColor)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: errorMessage)
        .onChange(of: errorMessage) { oldValue, newValue in
            guard oldValue == nil, newValue != nil else { return }
            withAnimation(.linear(duration: 0.45)) {
                shakeAmount += 1
            }
        }
    }
}

import SwiftUI

struct CustomSecureField: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    var isValid: Bool = true
    var errorMessage: String? = nil
    
    @FocusState private var isFocused: Bool
    @State private var isSecured: Bool = true
    @State private var shakeAmount: CGFloat = 0
    
    private var activeColor: Color {
        if !text.isEmpty && !isValid {
            return Color.appDanger
        } else if isFocused || !text.isEmpty {
            return Color.appPrimary
        } else {
            return Color.appBorder
        }
    }
    
    private var lineWidth: CGFloat {
        if isFocused {
            return 2.0
        } else if !text.isEmpty {
            return 1.5
        } else {
            return 1.0
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(activeColor)
            
            HStack {
                ZStack(alignment: .leading) {
                    if isSecured {
                        SecureField(placeholder, text: $text)
                            .focused($isFocused)
                            .foregroundStyle(Color.appPrimary)
                    } else {
                        TextField(placeholder, text: $text)
                            .focused($isFocused)
                    }
                }
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSecured.toggle()
                    }
                    isFocused = true
                } label: {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(activeColor)
                        .accentColor(.clear)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            .frame(height: 20)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.appPrimary.opacity(isFocused ? 0.06 : 0))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(activeColor, lineWidth: lineWidth)
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .scaleEffect(isFocused ? 1.015 : 1.0)
            .modifier(ShakeEffect(animatableData: shakeAmount))
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption2)
                    .foregroundStyle(Color.appDanger)
                    .padding(.horizontal, 4)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: activeColor)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: errorMessage)
        .onChange(of: errorMessage) { oldValue, newValue in
            guard oldValue == nil, newValue != nil else { return }
            withAnimation(.linear(duration: 0.45)) {
                shakeAmount += 1
            }
        }
    }
}
