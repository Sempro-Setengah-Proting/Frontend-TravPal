//
//  NotificationViewModel.swift
//  TravPal
//
//  Created by Revan Arturito on 08/10/26.
//

import Foundation

// SEMENTARA

enum NotificationKind {
    case system(message: String)
    case account(device: String)
    case expense(message: String, number: String)

    var filter: NotificationFilter {
        switch self {
            case .system:  return .system
            case .account: return .account
            case .expense: return .expense
        }
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let kind: NotificationKind
    let time: String
    var isUnread: Bool = true
}
