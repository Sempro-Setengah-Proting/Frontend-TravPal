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
    
    @FocusState var isFocused: Bool
    
    private var activeColor: Color {
        if isFocused || !text.isEmpty {
            return Color.appPrimary
        } else {
            return Color.appBorder
        }
    }
    
    private var lineWidth: CGFloat {
        if isFocused || !text.isEmpty {
            return 1.0
        } else {
            return 1.5
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
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(activeColor, lineWidth: lineWidth)
                )
                .keyboardType(.default)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            
        }
    }
}

import SwiftUI

struct CustomSecureField: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    @State private var isSecured: Bool = true
    
    private var activeColor: Color {
        if isFocused || !text.isEmpty {
            return Color.appPrimary
        } else {
            return Color.appBorder
        }
    }
    
    private var lineWidth: CGFloat {
        if isFocused || !text.isEmpty {
            return 1.0
        } else {
            return 1.5
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
                
                Button(action: {
                    isSecured.toggle()
                    isFocused = true
                }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(activeColor)
                        .accentColor(.clear)
                }
            }
            .frame(height: 20)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(activeColor, lineWidth: lineWidth)
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
        }
    }
}
