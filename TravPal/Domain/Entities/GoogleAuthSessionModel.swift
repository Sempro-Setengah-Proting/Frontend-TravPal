//
//  GoogleAuthSessionModel.swift
//  TravPal
//
//  Created by Revan Arturito on 02/10/26.
//

import Foundation

struct GoogleAuthSessionModel: Equatable {
    let user: UserModel
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
}
