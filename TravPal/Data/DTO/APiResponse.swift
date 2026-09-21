//
//  APiResponse.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let message: String?
    let data: T
}

struct APIErrorResponse: Decodable {
    let message: String
}
