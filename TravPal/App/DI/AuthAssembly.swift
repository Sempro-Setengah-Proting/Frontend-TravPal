//
//  AuthAsembly.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation
import Swinject
import Alamofire

final class AuthAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: Data Source
        container.register(AuthRemoteDataSourceProtocol.self) {
            resolver in AuthRemoteDataSource(session: resolver.resolve(Session.self)!)
        }
        .inObjectScope(.container)
        
        // MARK: Repository
        container.register(AuthRepositoryProtocol.self) { resolver in
            AuthRepository(remoteDataSource: resolver.resolve(AuthRemoteDataSourceProtocol.self)!)
        }
        .inObjectScope(.container)
        
        // MARK: Use Cases
        container.register(LoginUseCaseProtocol.self) { resolver in
            LoginUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(RegisterUseCaseProtocol.self) { resolver in
            RegisterUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(GenerateOTPUseCaseProtocol.self) { resolver in
            GenerateOTPUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(VerifyOTPUseCaseProtocol.self) { resolver in
            VerifyOTPUseCase(repository: resolver.resolve(AuthRepositoryProtocol.self)!)
        }
        
        // MARK: ViewModels
        container.register(LoginViewModel.self) { resolver in
            MainActor.assumeIsolated {
                LoginViewModel(loginUseCase: resolver.resolve(LoginUseCaseProtocol.self)!)
            }
        }    }
}
