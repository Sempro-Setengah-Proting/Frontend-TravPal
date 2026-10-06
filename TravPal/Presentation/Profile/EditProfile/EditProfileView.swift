//
//  EditProfileView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(profile: UserProfileModel) {
        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.resolve(EditProfileViewModel.self, argument: profile)
        )
    }
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
                    viewModel.activeSheet = .name
                }
                VSpace(.appSpacingV8)
                ProfileMenuRow(icon: "", title: "Email", showTrailingIcon: false) {
                    viewModel.activeSheet = .email
                }
                VSpace(.appSpacingV8)
                ProfileMenuRow(icon: "", title: "Phone Number", showTrailingIcon: false) {
                    viewModel.activeSheet = .phone
                }
                VSpace(.appSpacingV8)
            }
            VSpace(.appSpacingV20)
            ProfileMenuCard {
                ProfileMenuRow(
                    icon: "",
                    title: "Delete Account",
                    tint: .appDanger,
                    showTrailingIcon: false
                ) { }
            }
            Spacer()
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .name:
                EditNameView(name: viewModel.profile.name, onSaved: viewModel.didUpdate)
            case .email:
                EditEmailView(email: viewModel.profile.email, onSaved: viewModel.didUpdate)
            case .phone:
                EditPhoneView(phoneNumber: viewModel.profile.phoneNumber, onSaved: viewModel.didUpdate)
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
        EditProfileView(
            profile: UserProfileModel(
                name: "Revan Arturito",
                email: "revan@mail.com",
                phoneNumber: "08123456789"
            )
        )
    }
}

