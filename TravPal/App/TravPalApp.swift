import SwiftUI
import GoogleSignIn

@main
@MainActor
struct TravPalApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appState: AppState

    init() {
        guard
            let clientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String,
            !clientID.isEmpty,
            let serverClientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_SERVER_CLIENT_ID") as? String,
            !serverClientID.isEmpty
        else {
            fatalError("GOOGLE_CLIENT_ID atau GOOGLE_SERVER_CLIENT_ID belum diisi di Config/Secret.xcconfig.")
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientID,
            serverClientID: serverClientID
        )
        _appState = StateObject(wrappedValue: DIContainer.shared.resolve(AppState.self))
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .animation(.default, value: appState.isLoggedIn)
            .environmentObject(appState)
            .onChange(of: scenePhase, initial: true) { _, phase in
                if phase == .active {
                    appState.startSessionMonitoring()
                } else {
                    appState.stopSessionMonitoring()
                }
            }
            .alert(
                "Penyimpanan sesi",
                isPresented: Binding(
                    get: { appState.sessionError != nil },
                    set: { if !$0 { appState.sessionError = nil } }
                )
            ) {
                Button("OK", role: .cancel) { appState.sessionError = nil }
            } message: {
                Text(appState.sessionError ?? "")
            }
        }
    }
}
