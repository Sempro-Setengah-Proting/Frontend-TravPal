//
//  AuthSessionDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct AuthSessionDTO: Decodable {
    let user: UserDTO
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
    
    func toDomain() -> AuthSessionModel {
        AuthSessionModel(user: user.toDomain(), accessToken: accessToken)
    }
}
