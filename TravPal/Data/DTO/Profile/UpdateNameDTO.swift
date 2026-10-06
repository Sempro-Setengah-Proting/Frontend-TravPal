//
//  UpdateNameDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

struct UpdateNameRequestDTO: Encodable {
    let name: String
}

struct UpdateNameResponseDTO: Decodable {
    let status: String?
    let message: String?
}
