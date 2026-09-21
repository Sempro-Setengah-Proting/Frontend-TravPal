//
//  DeviceIdentifier.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import UIKit

enum DeviceIdentifier {
    private static let storageKey = "com.travpal.device_id"

    static var current: String {
        if let saved = UserDefaults.standard.string(forKey: storageKey) {
            return saved
        }
        let newId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        UserDefaults.standard.set(newId, forKey: storageKey)
        return newId
    }
}
