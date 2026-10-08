//
//  NotificationView.swift
//  TravPal
//
//  Created by Revan Arturito on 08/10/26.
//

import SwiftUI

struct NotificationRow: View {
    let item: NotificationItem
    
    var body: some View {
        switch item.kind {
            case let .system(message):
                SystemNotificationView(message: message, time: item.time, isUnread: item.isUnread)
            case let .account(device):
                AccountNotificationView(device: device, time: item.time)
            case let .expense(message, number):
                ExpensesNotificationView(message: message, time: item.time, number: number)
        }
    }
}

struct NotificationView: View {
    @State private var selected: NotificationFilter = .all
    
    // DUMMY SEMENTARA
    private let items: [NotificationItem] = [
        NotificationItem(kind: .system(message: "3 new places near Bali"), time: "5h ago"),
        NotificationItem(kind: .account(device: "iPhone 15 Pro"), time: "Thursday, 10:10", isUnread: false),
        NotificationItem(kind: .expense(message: "test", number: "Rp. 1.000.000"), time: "Thursday, 10:10", isUnread: false)
    ]
    
    var body: some View {
        VStack {
            VSpace(.appSpacingV20)
            NotificationFilterPillView(selected: $selected)
            VSpace(.appSpacingV20)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) {
                        item in NotificationRow(item: item)
                    }
                }
            }
        }
        .backgroundStyle(Color.appBackground)
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Notifications")
            }
        }
    }
}

#Preview {
    NotificationView()
}
