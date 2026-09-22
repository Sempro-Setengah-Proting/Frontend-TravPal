//
//  AuthErrorMapper.swift
//  TravPal
//
//  Created by Revan Arturito on 22/09/26.
//

import Foundation

extension AuthError {
    static func map(from serverMessage: String) -> AuthError {
        let normalized = serverMessage.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch normalized {
        case "email already registered", "email already exists":
            return .emailAlreadyRegistered
            
        case "invalid otp", "otp invalid":
            return .invalidOTP
            
        case "otp expired", "expired otp":
            return .otpExpired
            
        case "user not found":
            return .userNotFound
            
        case "invalid password", "wrong password":
            return .wrongPassword
            
        default:
            return .custom(message: serverMessage)
        }
    }
}
