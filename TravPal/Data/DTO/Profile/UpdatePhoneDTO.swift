//
//  UpdatePhoneDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

struct UpdatePhoneRequestDTO: Encodable {
    let phone: String
}

struct UpdatePhoneResponseDTO: Decodable {
    let status: String?
    let message: String?
}
