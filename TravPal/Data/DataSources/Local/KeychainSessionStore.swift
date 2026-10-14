//
//  KeychainSessionStore.swift
//  TravPal
//
//  Created by Revan Arturito on 14/10/26.
//

import Foundation
import Security

struct StoredSession: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
    let deviceID: String

    init(session: AuthSessionModel, deviceID: String, issuedAt: Date) {
        accessToken = session.accessToken
        refreshToken = session.refreshToken
        expiresAt = issuedAt.addingTimeInterval(TimeInterval(session.expiresIn))
        self.deviceID = deviceID
    }
}

final class KeychainSessionStore {
    private let service: String
    private let account = "auth-session"

    init(service: String = (Bundle.main.bundleIdentifier ?? "TravPal") + ".session") {
        self.service = service
    }

    private var query: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }

    func read() throws -> StoredSession? {
        var query = query
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw KeychainError(status: status) }
        guard let data = result as? Data else {
            throw KeychainError(status: errSecDecode)
        }
        return try JSONDecoder().decode(StoredSession.self, from: data)
    }

    func save(_ session: StoredSession) throws {
        let data = try JSONEncoder().encode(session)
        let attributes: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status == errSecItemNotFound {
            var item = query
            item[kSecValueData as String] = data
            item[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            let addStatus = SecItemAdd(item as CFDictionary, nil)
            guard addStatus == errSecSuccess else { throw KeychainError(status: addStatus) }
        } else if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }

    func clear() throws {
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError(status: status)
        }
    }
}

private struct KeychainError: LocalizedError {
    let status: OSStatus

    var errorDescription: String? {
        "Penyimpanan sesi tidak dapat diakses (Keychain: \(status)). Coba lagi."
    }
}
