//
//  UserDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct UserDTO: Decodable {
    let id: String
    let username: String
    let email: String
    
    func toDomain() -> UserModel {
        UserModel(id: id, username: username, email: email)
    }
}
