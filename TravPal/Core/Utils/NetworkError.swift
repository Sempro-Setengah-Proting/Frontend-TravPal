//
//  NetworkError.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case server(message: String)
    case underlying(Error)
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        case .underlying(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "Terjadi kesalahan, coba lagi ya."
        }
    }
}
