//
//  TravPalApp.swift
//  TravPal
//
//  Created by Revan Arturito on 24/08/26.
//

import SwiftUI
import GoogleSignIn

@main
struct TravPalApp: App {
    init() {
        guard
            let clientId = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String,
            !clientId.isEmpty,
            let serverClientId = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_SERVER_CLIENT_ID") as? String,
            !serverClientId.isEmpty
        else {
            fatalError(
                "GOOGLE_CLIENT_ID atau GOOGLE_SERVER_CLIENT_ID tidak ditemukan/invalid di Info.plist. " +
                "Pastikan Config/Secret.xcconfig sudah diisi dan di-link ke Build Configuration, " +
                "lalu Clean Build Folder."
            )
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientId,
            serverClientID: serverClientId
        )
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
