//
//  AuthSession.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct AuthSessionModel: Equatable {
    let user: UserModel
    let accessToken: String
}
