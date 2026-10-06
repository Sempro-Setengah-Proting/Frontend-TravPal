//
//  EditProfileView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct EditProfileView: View {
    @State private var showSheet = false
    @Environment(\.dismiss) private var dismiss
    // ini biar ga tampil navbar
    
    var body: some View {
        VStack {
            VSpace(.appSpacingV20)
            ZStack {
                Circle()
                    .stroke(Color.appPrimary, lineWidth: 2)
                    .frame(width: 150, height: 150)
                
                Image("profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
            VSpace(.appSpacingV20)
            Text("Revan Arturito")
            VSpace(.appSpacingV20)
            ProfileMenuCard {
                VSpace(.appSpacingV8)
                ProfileMenuRow(icon: "", title: "Name", showTrailingIcon: false) {
                    showSheet = true
                }
                VSpace(.appSpacingV8)
                ProfileMenuRow(icon: "", title: "Email", showTrailingIcon: false) { }
                VSpace(.appSpacingV8)
                ProfileMenuRow(icon: "", title: "Phone Number", showTrailingIcon: false) { }
                VSpace(.appSpacingV8)
            }
            VSpace(.appSpacingV20)
            ProfileMenuCard {
                ProfileMenuRow(
                    icon: "",
                    title: "Delete Account",
                    tint: .appDanger,
                    showTrailingIcon: false,
                ) { }
            }
            Spacer()
            
            Button("Buka Modal") {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    VStack {
                        Text("Ini isi modal")
                    }
                    .navigationTitle("Phone Number")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                showSheet = false
                            }
                        }
                        .sharedBackgroundVisibility(.hidden)
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                showSheet = true
                            }
                            .foregroundStyle(Color.appPrimary)
                            // .buttonStyle(.plain)
                        }
                        // kalau pakai .plain gabisa text doang, karena di dalam ToolbarItem, jdi harus pakai 👇 dawg
                        .sharedBackgroundVisibility(.hidden)
                    }
                }
                .presentationDetents([.height(750)])
            }
        }
        .padding(.horizontal)
        .background(LinearGradient.appBackground.ignoresSafeArea())
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit Profile")
                    .font(.appSemiBold22)
                    .foregroundStyle(Color.appPrimary)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.appPrimary)
                }
            }
            .sharedBackgroundVisibility(.hidden)
        }
        
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}

