//
//  HomeView.swift
//  TravPal
//
//  Created by Revan Arturito on 20/09/26.
//

import SwiftUI

struct HomeView: View {
    @State private var goToNotificationCentre = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Nadya")
            }
            .padding(.horizontal)
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        goToNotificationCentre = true
                    } label: {
                        Image(systemName: "bell")
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
            .navigationDestination(isPresented: $goToNotificationCentre) {
                NotificationView()
            }
        }
    }
}

#Preview {
    HomeView()
}
