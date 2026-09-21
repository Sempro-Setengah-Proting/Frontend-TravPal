//
//  NetworkAssembl.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

import Foundation
import Swinject
import Alamofire

//  Registrasi Alamofire Session sebagai singleton, dipakai semua RemoteDataSource.
final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Session.self) { _ in
            Session.default
        }
        .inObjectScope(.container)
    }
}
