//
//  PendingRegistrationModel.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct PendingRegistrationModel: Equatable {
    let name: String
    let email: String
    let password: String
    let phoneNumber: String
    let deviceId: String
}
