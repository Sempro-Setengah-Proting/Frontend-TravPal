//
//  SessionManager.swift
//  TravPal
//
//  Created by Revan Arturito on 14/10/26.
//

import Foundation
import Combine
import Alamofire

enum SessionError: LocalizedError {
    case expired
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .expired: return "Sesi sudah berakhir. Silakan login kembali."
        case .invalidResponse: return "Respons sesi dari server tidak valid."
        }
    }
}

@MainActor
final class SessionManager: ObservableObject {
    struct Authorization {
        let token: String
        let sessionID: UUID
    }

    @Published private(set) var isLoggedIn = false

    private let keychain: KeychainSessionStore
    private let session: Session
    private let baseURL: URL
    private let refreshWindow: TimeInterval = 5 * 60
    private var storedSession: StoredSession?
    private var didRestore = false
    private var needsPersistence = false
    private var sessionID = UUID()
    private var refreshTask: Task<Void, Error>?

    init(keychain: KeychainSessionStore, session: Session, baseURL: URL = Constants.apiBaseURL) {
        self.keychain = keychain
        self.session = session
        self.baseURL = baseURL
    }

    func restore() throws {
        guard !didRestore else { return }
        storedSession = try keychain.read()
        didRestore = true
        isLoggedIn = storedSession != nil
    }

    func save(_ value: AuthSessionModel, deviceID: String, issuedAt: Date) throws {
        try validate(value)
        let saved = StoredSession(session: value, deviceID: deviceID, issuedAt: issuedAt)
        try keychain.save(saved)
        sessionID = UUID()
        refreshTask?.cancel()
        refreshTask = nil
        storedSession = saved
        needsPersistence = false
        didRestore = true
        isLoggedIn = true

        do {
            if let persistedSession = try keychain.read() {
                print("[Keychain] Access token setelah login: \(persistedSession.accessToken)")
            }
        } catch {
            print("[Keychain] Gagal membaca token: \(error.localizedDescription)")
        }
    }

    func clear() throws {
        sessionID = UUID()
        refreshTask?.cancel()
        refreshTask = nil
        storedSession = nil
        needsPersistence = false
        didRestore = true
        isLoggedIn = false
        try keychain.clear()
    }

    func refreshIfNeeded() async throws {
        try restore()
        guard storedSession != nil else { return }
        _ = try await authorization()
    }

    func authorization() async throws -> Authorization {
        try restore()
        try persistIfNeeded()
        guard let current = storedSession else { throw SessionError.expired }
        let expectedID = sessionID
        if refreshTask != nil || current.expiresAt.timeIntervalSinceNow <= refreshWindow {
            try await refresh()
        }
        guard sessionID == expectedID, let latest = storedSession else {
            throw CancellationError()
        }
        return Authorization(token: latest.accessToken, sessionID: sessionID)
    }

    // Request yang mendapat 401 mungkin masih memakai token sebelum refresh terakhir.
    func renew(_ rejected: Authorization) async throws -> Authorization {
        try validateSession(rejected)
        guard storedSession?.accessToken == rejected.token else {
            return try await authorization()
        }
        try await refresh()
        try validateSession(rejected)
        guard let latest = storedSession else { throw SessionError.expired }
        return Authorization(token: latest.accessToken, sessionID: sessionID)
    }

    func validateSession(_ authorization: Authorization) throws {
        guard authorization.sessionID == sessionID, storedSession != nil else {
            throw CancellationError()
        }
    }

    func expire(ifMatching authorization: Authorization) throws {
        guard authorization.sessionID == sessionID,
              storedSession?.accessToken == authorization.token else { return }
        try clear()
    }

    private func refresh() async throws {
        if let task = refreshTask {
            try await task.value
            return
        }
        guard let current = storedSession else { throw SessionError.expired }
        let expectedID = sessionID

        let task = Task { @MainActor [self] in
            defer {
                if sessionID == expectedID { refreshTask = nil }
            }
            let issuedAt = Date()
            // Langsung ke Session agar refresh tidak memicu refresh secara rekursif.
            let response = await session.request(
                baseURL.appendingPathComponent("identity/refresh-token"),
                method: .post,
                parameters: RefreshTokenRequestDTO(
                    refreshToken: current.refreshToken,
                    deviceID: current.deviceID
                ),
                encoder: JSONParameterEncoder.default
            ).serializingData().response

            try Task.checkCancellation()
            guard sessionID == expectedID else { throw CancellationError() }

            if response.response?.statusCode == 401 {
                try clear()
                throw SessionError.expired
            }
            let data = try response.result.get()
            guard let status = response.response?.statusCode, (200..<300).contains(status) else {
                let message = (try? JSONDecoder().decode(APIErrorResponse.self, from: data))?.message
                throw NetworkError.server(message: message ?? "Gagal memperbarui sesi. Coba lagi.")
            }
            let envelope = try JSONDecoder().decode(APIEnvelope<AuthSessionDTO>.self, from: data)
            guard envelope.isSuccess else {
                throw NetworkError.server(message: envelope.message ?? "Gagal memperbarui sesi.")
            }
            guard let dto = envelope.data else { throw SessionError.invalidResponse }
            let value = dto.toDomain()
            try validate(value)

            // Kedua token diganti bersama. Simpan di memori juga jika Keychain sementara gagal.
            storedSession = StoredSession(session: value, deviceID: current.deviceID, issuedAt: issuedAt)
            needsPersistence = true
            try persistIfNeeded()
        }
        refreshTask = task
        try await task.value
    }

    private func persistIfNeeded() throws {
        guard needsPersistence, let storedSession else { return }
        try keychain.save(storedSession)
        needsPersistence = false
    }

    private func validate(_ value: AuthSessionModel) throws {
        guard !value.accessToken.isEmpty, !value.refreshToken.isEmpty, value.expiresIn > 0 else {
            throw SessionError.invalidResponse
        }
    }
}
