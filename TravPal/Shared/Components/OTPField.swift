//
//  OTPField.swift
//  TravPal
//
//  Created by Revan Arturito on 22/09/26.
//

// Component dari https://github.com/EhsanAzish80/swiftui-snips/blob/main/Components/Inputs/OTPField/OTPField.swift
import SwiftUI

struct OTPField: View {
    @Binding var code: String
    let length: Int
    let onComplete: (String) -> Void

    @FocusState private var focused: Bool

    init(
        code: Binding<String>,
        length: Int = 6,
        onComplete: @escaping (String) -> Void = { _ in }
    ) {
        self._code = code
        self.length = length
        self.onComplete = onComplete
    }

    var body: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($focused)
                .opacity(0.01)
                .blendMode(.screen)

            HStack(spacing: 10) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { focused = true }
        }
        .onChange(of: code) { _, newValue in
            let filtered = String(newValue.filter(\.isNumber).prefix(length))
            if filtered != newValue { code = filtered }
            if filtered.count == length { onComplete(filtered) }
        }
        .onAppear { focused = true }
    }

    @ViewBuilder
    private func digitBox(at index: Int) -> some View {
        let digits = Array(code)
        let digit = index < digits.count ? String(digits[index]) : ""
        let isActive = focused && index == min(code.count, length - 1)

        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.Secondary.secondary200)
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(
                        isActive ? Color.appPrimary : Color.appBorder,
                        lineWidth: isActive ? 2 : 1
                    )
            }
            .frame(width: 48, height: 58)
            .overlay {
                Text(digit)
                    .font(.appBold24)
                    .foregroundColor(.appTextPrimary)
                    .scaleEffect(digit.isEmpty ? 0.5 : 1)
                    .opacity(digit.isEmpty ? 0 : 1)
                    .animation(.spring(response: 0.25, dampingFraction: 0.6), value: digit)
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isActive)
    }
}
