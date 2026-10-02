//
//  LoginDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
    let device_id: String
}

struct GoogleLoginRequestDTO: Encodable {
    let id_token: String
    let device_id: String
}
