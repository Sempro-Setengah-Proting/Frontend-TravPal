//
//  MainProfileView.swift
//  TravPal
//
//  Created by Revan Arturito on 06/10/26.
//

import SwiftUI

struct MainProfileView: View {
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
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
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // balik wok
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

#Preview {
    MainProfileView()
}
