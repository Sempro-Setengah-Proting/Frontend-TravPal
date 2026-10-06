//
//  EditNameViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Combine
 
@MainActor
final class EditNameViewModel: ObservableObject {
    @Published var name: String
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
 
    private let initialName: String
    private let updateNameUseCase: UpdateNameUseCaseProtocol
 
    init(name: String, updateNameUseCase: UpdateNameUseCaseProtocol) {
        self.name = name
        self.initialName = name
        self.updateNameUseCase = updateNameUseCase
    }
 
    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
 
    var canSave: Bool {
        !trimmedName.isEmpty && trimmedName != initialName
    }
 
    func save() async -> UserProfileModel? {
        guard canSave, !isLoading else { return nil }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
 
        do {
            return try await updateNameUseCase.execute(name: name)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
