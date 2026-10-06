//
//  MainProfileView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct MainProfileView: View {
    @StateObject private var viewModel: MainProfileViewModel
    
    @State private var goToEdit = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    init(viewModel: MainProfileViewModel = DIContainer.shared.resolve(MainProfileViewModel.self)) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
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
                    ProfileMenuRow(icon: "heart", title: "Favorite place") { }
                    VSpace(.appSpacingV8)
                    ProfileMenuRow(icon: "clock.arrow.circlepath", title: "History trip") { }
                    VSpace(.appSpacingV8)
                    ProfileMenuRow(icon: "key", title: "Change password") { }
                    VSpace(.appSpacingV8)
                }
                VSpace(.appSpacingV20)
                ProfileMenuCard {
                    ProfileMenuRow(
                        icon: "rectangle.portrait.and.arrow.right",
                        title: "Logout",
                        tint: .appDanger,
                        showChevron: false
                    ) { }
                }
                Spacer()
            }
            .padding(.horizontal)
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.appSemiBold22)
                        .foregroundStyle(Color.appPrimary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        goToEdit = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(Color.appPrimary)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $goToEdit) {
                if let profile = viewModel.profile {
                    EditProfileView(profile: profile)
                }
            }
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    MainProfileView()
}
