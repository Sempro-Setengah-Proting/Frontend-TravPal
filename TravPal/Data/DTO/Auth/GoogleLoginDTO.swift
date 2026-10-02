//
//  GoogleLoginDTO.swift
//  TravPal
//
//  Created by Revan Arturito on 23/09/26.
//

import Foundation

struct GoogleLoginRequestDTO: Encodable {
    let id_token: String
    let device_id: String
}

struct GoogleAuthSessionDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken  = "access_token"
        case refreshToken = "refresh_token"
        case tokenType    = "token_type"
        case expiresIn    = "expires_in"
    }

    func toDomain() -> GoogleAuthSessionModel {
        let user = decodeUserFromJWT(accessToken)
        return GoogleAuthSessionModel(
            user: user,
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresIn: expiresIn
        )
    }

    private func decodeUserFromJWT(_ jwt: String) -> UserModel {
        let segments = jwt.split(separator: ".")
        guard segments.count >= 2,
              let payloadData = base64URLDecode(String(segments[1])),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any]
        else {
            return UserModel(id: "", username: "", email: "")
        }

        let userId   = json["user_id"]  as? String ?? ""
        let username = json["username"] as? String ?? ""
        let email    = json["email"]    as? String ?? ""

        return UserModel(id: userId, username: username, email: email)
    }

    private func base64URLDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let remainder = base64.count % 4
        if remainder > 0 {
            base64.append(contentsOf: String(repeating: "=", count: 4 - remainder))
        }
        return Data(base64Encoded: base64)
    }
}
