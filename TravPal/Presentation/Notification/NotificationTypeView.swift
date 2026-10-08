//
//  NotificationTypeView.swift
//  TravPal
//
//  Created by Revan Arturito on 08/10/26.
//

import SwiftUI

struct SystemNotificationView: View {
    let message: String
    let time: String
    var isUnread: Bool = true

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: "info.circle").foregroundStyle(.blue))

            VStack(alignment: .leading, spacing: 4) {
                Text(message).font(.system(size: 17))
                Text(time).font(.system(size: 14)).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)

            if isUnread {
                Circle().fill(Color.blue).frame(width: 8, height: 8)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSecondary100)
        )
    }
}

struct AccountNotificationView: View {
    let device: String
    let time: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(Color.yellow.opacity(0.25))
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: "shield").foregroundStyle(.yellow))

            VStack(alignment: .leading, spacing: 4) {
                Text("Your account has just been logged in from an \(device)")
                    .font(.system(size: 17))
                Text(time).font(.system(size: 14)).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSecondary100)
        )
    }
}

struct ExpensesNotificationView: View {
    let message: String
    let time: String
    let number: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(Color.appPrimary)
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: "info").foregroundStyle(.yellow))
            VStack(alignment: .leading, spacing: 4) {
                Text(message)
                    .font(.system(size: 17))
                Text("Your part: \(number)")
                Text(time).font(.system(size: 14)).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.appSecondary100)
        )
    }
}
