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
    let username: String
}

struct RegisterResponseDTO: Decodable {
    let message: String?
}
