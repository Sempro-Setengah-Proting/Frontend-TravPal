//
//  Constant.swift
//  TravPal
//
//  Created by Revan Arturito on 27/08/26.
//

import Foundation

enum Constants {
    static let apiBaseURL: URL = {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
            !urlString.isEmpty,
            let url = URL(string: urlString)
        else {
            fatalError(
                "API_BASE_URL tidak ditemukan/invalid di Info.plist. " +
                "Pastikan Config/Secrets.xcconfig sudah diisi dan di-link ke Build Configuration " +
                "(Project > Info > Configurations), lalu Clean Build Folder."
            )
        }
        return url
    }()
}
