//
//  AuthRepositoryProtocol.swift
//  TravPal
//
//  Created by Revan Arturito on 21/09/26.
//

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthSessionModel
    
    func register(email: String, password: String, phoneNumber: String, name: String, deviceId: String, registrationToken: String) async throws
    
    func generateOTP(email: String) async throws
    
    func verifyOTP(email: String, otp: String) async throws -> String
}
