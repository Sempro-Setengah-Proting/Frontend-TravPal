//
//  OTPDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct GenerateOTPRequestDTO: Encodable {
    let email: String
}

struct GenerateOTPResponseDTO: Decodable {
    let status: String?
    let message: String?
}

struct VerifyOTPRequestDTO: Encodable {
    let email: String
    let otp: String
}

struct VerifyOTPResponseDTO: Decodable {
    let registrationToken: String
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case registrationToken = "registration_token"
        case expiresIn = "expires_in"
    }
}
