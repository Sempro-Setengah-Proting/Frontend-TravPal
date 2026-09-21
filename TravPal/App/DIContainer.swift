//
//  DIContainer.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    
    private let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        assembler = Assembler(
            [
                NetworkAssembly(),
                AuthAssembly()
            ],
            container: container
        )
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Dependency \(T.self) belum terdaftar. Cek Assembly yang relevan.")
        }
        return resolved
    }

    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        guard let resolved = container.resolve(type, argument: argument) else {
            fatalError("Dependency \(T.self) dengan argument \(Arg.self) belum terdaftar.")
        }
        return resolved
    }
}
