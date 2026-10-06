//
//  AppState.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false

    func didLogin() { isLoggedIn = true }
    func didLogout() { isLoggedIn = false }  
}
