//
//  ProfileError.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

enum ProfileError: LocalizedError {
    case validation(String)
    var errorDescription: String? {
        switch self { case .validation(let m): return m }
    }
}
