//
//  PhoneNumberValidator.swift
//  TravPal
//
//  Created by Revan Arturito on 22/09/26.
//

import Foundation

enum PhoneNumberValidator {
    private static let minLength = 9
    private static let maxLength = 14

    static func isValid(_ phoneNumber: String) -> Bool {
        guard phoneNumber.count >= minLength, phoneNumber.count <= maxLength else { return false }
        return phoneNumber.allSatisfy(\.isNumber)
    }
}
