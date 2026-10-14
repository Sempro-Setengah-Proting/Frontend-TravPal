//
//  APiResponse.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

struct APIEnvelope<T: Decodable>: Decodable {
    let status: String
    let message: String?
    let data: T?

    var isSuccess: Bool { status == "success" }
}

struct APIErrorResponse: Decodable {
    let message: String
}
