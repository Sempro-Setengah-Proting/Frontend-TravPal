//
//  MainProfileViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Combine
 
@MainActor
final class MainProfileViewModel: ObservableObject {
    @Published private(set) var profile: UserProfileModel?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
 
    private let getProfileUseCase: GetProfileUseCaseProtocol
 
    init(getProfileUseCase: GetProfileUseCaseProtocol) {
        self.getProfileUseCase = getProfileUseCase
    }
 
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
 
        do {
            profile = try await getProfileUseCase.execute()
        } catch is CancellationError {
            // 
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
