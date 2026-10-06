//
//  UpdateEmail.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

struct UpdateEmailRequestDTO: Encodable {
    let email: String
}

struct UpdateEmailResponseDTO: Decodable {
    let status: String?
    let message: String?
}
