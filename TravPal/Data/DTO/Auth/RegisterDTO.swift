//
//  RegisterDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct RegisterRequestDTO: Encodable {
    let email: String
    let password: String
    let phone_number: String
    let device_id: String
    let name: String
    let registration_token: String
}

struct RegisterResponseDTO: Decodable {
    let message: String?
}
