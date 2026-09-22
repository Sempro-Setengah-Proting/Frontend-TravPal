//
//  AuthErrors.swift
//  TravPal
//
//  Created by Revan Arturito on 22/09/26.
//

import Foundation

enum AuthError: LocalizedError, Equatable {
    case emailAlreadyRegistered
    case invalidOTP
    case otpExpired
    case userNotFound
    case wrongPassword
    case custom(message: String)
    case unknown

     var errorDescription: String? {
        switch self {
        case .emailAlreadyRegistered:
            return "Email ini sudah terdaftar. Silakan gunakan email lain atau langsung masuk."
        case .invalidOTP:
            return "Kode OTP yang kamu masukkan salah. Coba periksa kembali."
        case .otpExpired:
            return "Kode OTP telah kedaluwarsa. Silakan kirim ulang kode baru."
        case .userNotFound:
            return "Akun tidak ditemukan. Silakan daftar terlebih dahulu."
        case .wrongPassword:
            return "Kata sandi salah. Silakan coba lagi."
        case .custom(let message):
            return message
        case .unknown:
            return "Terjadi kesalahan, silakan coba beberapa saat lagi."
        }
    }
}

