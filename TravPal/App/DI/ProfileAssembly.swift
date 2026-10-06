//
//  ProfileAssembly.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation
import Swinject
import Alamofire

final class ProfileAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: Data Source
        container.register(ProfileRemoteDataSourceProtocol.self) { resolver in
            ProfileRemoteDataSource(client: resolver.resolve(APIClientProtocol.self)!)
        }
        .inObjectScope(.container)

        // MARK: Repository
        container.register(ProfileRepositoryProtocol.self) { resolver in
            ProfileRepository(remoteDataSource: resolver.resolve(ProfileRemoteDataSourceProtocol.self)!)
        }
        .inObjectScope(.container)

        // MARK: Use Cases
        container.register(GetProfileUseCaseProtocol.self) { resolver in
            GetProfileUseCase(repository: resolver.resolve(ProfileRepositoryProtocol.self)!)
        }

        container.register(UpdateNameUseCaseProtocol.self) { resolver in
            UpdateNameUseCase(repository: resolver.resolve(ProfileRepositoryProtocol.self)!)
        }

        container.register(UpdateEmailUseCaseProtocol.self) { resolver in
            UpdateEmailUseCase(repository: resolver.resolve(ProfileRepositoryProtocol.self)!)
        }

        container.register(UpdatePhoneNumberUseCaseProtocol.self) { resolver in
            UpdatePhoneNumberUseCase(repository: resolver.resolve(ProfileRepositoryProtocol.self)!)
        }

        // MARK: ViewModels
        container.register(MainProfileViewModel.self) { resolver in
            MainActor.assumeIsolated {
                MainProfileViewModel(
                    getProfileUseCase: resolver.resolve(GetProfileUseCaseProtocol.self)!
                )
            }
        }

        container.register(EditProfileViewModel.self) { (_, profile: UserProfileModel) in
            MainActor.assumeIsolated {
                EditProfileViewModel(profile: profile)
            }
        }

        container.register(EditNameViewModel.self) { (resolver, name: String) in
            MainActor.assumeIsolated {
                EditNameViewModel(
                    name: name,
                    updateNameUseCase: resolver.resolve(UpdateNameUseCaseProtocol.self)!
                )
            }
        }

        container.register(EditEmailViewModel.self) { (resolver, email: String) in
            MainActor.assumeIsolated {
                EditEmailViewModel(
                    email: email,
                    updateEmailUseCase: resolver.resolve(UpdateEmailUseCaseProtocol.self)!
                )
            }
        }

        container.register(EditPhoneViewModel.self) { (resolver, phoneNumber: String) in
            MainActor.assumeIsolated {
                EditPhoneViewModel(
                    phoneNumber: phoneNumber,
                    updatePhoneNumberUseCase: resolver.resolve(UpdatePhoneNumberUseCaseProtocol.self)!
                )
            }
        }
    }
}
