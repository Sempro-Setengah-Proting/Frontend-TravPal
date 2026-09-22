//
//  PasswordValidator.swift
//  TravPal
//
//  Created by Revan Arturito on 22/09/26.
//

import Foundation

enum PasswordValidator {
    private static let pattern = #"^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>_\-+=~`\[\]/\\;']).{8,12}$"#

    static let errorMessage = "Password harus 8-12 karakter, ada huruf besar & karakter spesial"

    static func isValid(_ password: String) -> Bool {
        password.range(of: pattern, options: .regularExpression) != nil
    }
}

