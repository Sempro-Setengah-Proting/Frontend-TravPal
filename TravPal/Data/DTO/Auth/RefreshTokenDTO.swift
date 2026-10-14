//
//  RefreshTokenDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 14/10/26.
//


import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let refreshToken: String
    let deviceID: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case deviceID = "device_id"
    }
}
