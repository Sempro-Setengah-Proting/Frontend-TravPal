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
        assembler = Assembler() [
            Network
        ]
    }
}
