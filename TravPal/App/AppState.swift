import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    @Published var sessionError: String?

    private let sessionManager: SessionManager
    private var refreshLoop: Task<Void, Never>?

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        sessionManager.$isLoggedIn.assign(to: &$isLoggedIn)
        do {
            try sessionManager.restore()
        } catch {
            sessionError = error.localizedDescription
        }
    }

    func startSessionMonitoring() {
        guard refreshLoop == nil else { return }
        do {
            try sessionManager.restore()
        } catch {
            sessionError = error.localizedDescription
            return
        }

        refreshLoop = Task { [weak self] in
            while !Task.isCancelled {
                do {
                    try await self?.sessionManager.refreshIfNeeded()
                } catch is CancellationError {
                    if Task.isCancelled { break }
                } catch {
                    // Offline/5xx tidak menghapus sesi. Dicoba lagi pada pemeriksaan berikutnya.
                    // HTTP 401 dari refresh sudah ditangani oleh SessionManager.
                }
                do {
                    try await Task.sleep(for: .seconds(60))
                } catch {
                    break
                }
            }
        }
    }

    func stopSessionMonitoring() {
        refreshLoop?.cancel()
        refreshLoop = nil
    }

    // Dipakai LoginView/RegisterView yang sudah ada. Token disimpan oleh repository.
    func didLogin() {
        isLoggedIn = sessionManager.isLoggedIn
    }

    func didLogout() {
        do {
            try sessionManager.clear()
        } catch {
            sessionError = error.localizedDescription
        }
    }

    deinit {
        refreshLoop?.cancel()
    }
}
