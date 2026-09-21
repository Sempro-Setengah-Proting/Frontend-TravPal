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
    let message: String?
}

struct VerifyOTPRequestDTO: Encodable {
    let email: String
    let otp: String
}
