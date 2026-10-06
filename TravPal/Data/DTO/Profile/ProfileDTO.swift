//
//  ProfileDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

struct ProfileDTO: Decodable {
    let name: String
    let email: String
    let phone_number: String

    func toDomain() -> UserProfileModel {
        UserProfileModel(name: name, email: email, phoneNumber: phone_number)
    }
}

struct UpdateProfileRequestDTO: Encodable {
    var name: String?
    var email: String?
    var phone_number: String?
}
