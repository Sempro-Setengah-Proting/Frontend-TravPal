//
//  ProfileRepositoryProtocol.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func getProfile() async throws -> UserProfileModel
    func updateName(name: String) async throws -> UserProfileModel
    func updateEmail(email: String) async throws -> UserProfileModel
    func updatePhone(phone: String) async throws -> UserProfileModel
}
