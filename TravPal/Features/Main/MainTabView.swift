//
//  MainTabView.swift
//  TravPal
//
//  Created by Revan Arturito on 31/08/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Text("Halaman 1")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("Halaman 2")
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
            Text("Halaman 3")
                .tabItem {
                    Label(
                        title: { Text("My Trip") },
                        icon: { Image(_internalSystemName: "location.bottomleft.forward.to.point.topright.scurvepath") }
                    )
                }
            Text("Halaman 4")
                .tabItem {
                    Label("You", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
