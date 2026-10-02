//
//  AuthSession.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct AuthSessionModel: Equatable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
}

