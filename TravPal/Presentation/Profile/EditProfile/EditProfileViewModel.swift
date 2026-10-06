//
//  EditProfileViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Combine

enum EditProfileSheet: Identifiable {
    case name, email, phone
    var id: Self { self }
}

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published private(set) var profile: UserProfileModel
    @Published var activeSheet: EditProfileSheet?

    init(profile: UserProfileModel) {
        self.profile = profile
    }

    func didUpdate(_ profile: UserProfileModel) {
        self.profile = profile
    }
}
