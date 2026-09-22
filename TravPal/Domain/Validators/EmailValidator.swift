//
//  EmailValidator.swift
//  TravPal
//
//  Created by Revan Arturito on 22/09/26.
//

import Foundation

enum EmailValidator {
    private static let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

    static func isValid(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
