//
//  NotificationFilterPillView.swift
//  TravPal
//
//  Created by Revan Arturito on 08/10/26.
//

import SwiftUI

enum NotificationFilter: String, CaseIterable, Identifiable {
    case all = "All", trip = "Trip", expense = "Expense", account = "Account", system = "System"
    var id: Self { self }
}

struct NotificationFilterPillView: View {
    @Binding var selected: NotificationFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(NotificationFilter.allCases) {
                    filter in Button {
                        selected = filter
                    } label: {
                        Text(filter.rawValue)
                            .foregroundStyle(selected == filter ? Color.appBackground : Color.appTextPrimary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selected == filter ? Color.appPrimary : Color.appGrey)
                            )
                    }
                    .buttonStyle(.plain)
                    .buttonBorderShape(.capsule)
                }
            }
        }
        .scrollClipDisabled()
        .padding(.horizontal, 20)
    }
}
