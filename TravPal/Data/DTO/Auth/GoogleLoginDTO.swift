//
//  GoogleLoginDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 23/09/26.
//

import Foundation

struct GoogleLoginRequestDTO: Encodable {
    let id_token: String
    let device_id: String
}
