//
//  AppColors.swift
//  TravPal
//
//  Created by Revan Arturito on 27/08/26.
//

import SwiftUI

extension Color {
    struct Primary {
        static let primary900 = Color(hex: "165E6C")
        static let primary800 = Color(hex: "1B7485")
        static let primary700 = Color(hex: "208CA1")
        static let primary600 = Color(hex: "26A5BD")
        static let primary500 = Color(hex: "2BBBD7") // Main / Base Primary
        static let primary400 = Color(hex: "60CCE1")
        static let primary300 = Color(hex: "8ADAE9")
        static let primary200 = Color(hex: "B5E7F1")
        static let primary100 = Color(hex: "D5F1F7")
        static let primary50  = Color(hex: "EAF8FB")
    }
    
    struct Secondary {
        static let secondary950 = Color(hex: "000000") // Black/Deepest
        static let secondary900 = Color(hex: "677778")
        static let secondary800 = Color(hex: "809494")
        static let secondary700 = Color(hex: "9AB2B3")
        static let secondary600 = Color(hex: "B5D1D2")
        static let secondary500 = Color(hex: "CEEEEF") // Main / Base Secondary
        static let secondary400 = Color(hex: "DAF2F3")
        static let secondary300 = Color(hex: "E4F6F6")
        static let secondary200 = Color(hex: "EEF9F9")
        static let secondary100 = Color(hex: "F5FCFC")
        static let secondary50  = Color(hex: "FAFDFD")
    }
    
    struct Neutral {
        static let neutral950 = Color(hex: "091413") // Darkest / Almost Black
        static let neutral900 = Color(hex: "2C2C2C")
        static let neutral800 = Color(hex: "3F3F3F")
        static let neutral700 = Color(hex: "666666")
        static let neutral600 = Color(hex: "AAAAAA")
        static let neutral500 = Color(hex: "CCCCCC") // Base Gray
        static let neutral400 = Color(hex: "D9D9D9")
        static let neutral300 = Color(hex: "EEEEEE")
        static let neutral200 = Color(hex: "F4F4F4")
        static let neutral100 = Color(hex: "FBFBFB")
    }
    
    struct Alert {
        static let success = Color(hex: "16A34A") // Hijau
        static let info    = Color(hex: "2563EB") // Biru
        static let danger  = Color(hex: "DC2626") // Merah
        static let warning = Color(hex: "FFCC00") // Kuning
    }
    
    static let appSuccess = Alert.success
    static let appInfo    = Alert.info
    static let appDanger   = Alert.danger
    static let appWarning  = Alert.warning
    
    static let appBackground = Neutral.neutral100
    static let appTextPrimary = Neutral.neutral950
    static let appTextSecondary = Neutral.neutral700
    static let appBorder = Neutral.neutral400
    
    static let appSecondary = Secondary.secondary500
    static let appPrimary = Primary.primary500
}
