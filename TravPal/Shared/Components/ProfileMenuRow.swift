//
//  ProfileMenuRow.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    var tint: Color = .appPrimary
    var showTrailingIcon: Bool = true
    var showChevron: Bool = true
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if showTrailingIcon {
                    Image(systemName: icon)
                        .frame(width: 20)
                }
                Text(title)
                    .fontWeight(.semibold)
                Spacer()
                if showChevron {
                    Image(systemName: "chevron.right")
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(tint)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct ProfileMenuCard<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
