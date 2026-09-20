//
//  Toast.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//

import SwiftUI

struct DynamicIslandToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let systemImage: String
    let tintColor: Color

    @State private var progress: CGFloat = 0   // 0 = titik kecil di island, 1 = pill penuh di posisi akhir
    @State private var contentOpacity: CGFloat = 0
    @State private var dismissTask: Task<Void, Never>?

    // Dimensi Dynamic Island asli (iPhone 14 Pro+, compact)
    private let islandWidth: CGFloat = 126
    private let islandHeight: CGFloat = 37

    private let finalWidth: CGFloat = 320
    private let finalHeight: CGFloat = 64
    private let gap: CGFloat = 20 // jarak pill ke bawah island

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if isPresented {
                GeometryReader { geometry in
                    let topInset = geometry.safeAreaInsets.top

                    let currentWidth = lerp(islandWidth * 0.35, finalWidth, progress)
                    let currentHeight = lerp(islandHeight * 0.5, finalHeight, progress)

                    // Titik pusat island (tempat toast "lahir")
                    let islandCenterY = topInset > 0 ? topInset + islandHeight / 2 : 40
                    // Posisi akhir pill setelah "jatuh" ke bawah
                    let finalCenterY = islandCenterY + gap + finalHeight / 2
                    // Interpolasi posisi: dari pusat island -> posisi akhir di bawah
                    let currentY = lerp(islandCenterY, finalCenterY, progress)

                    HStack(spacing: .appSpacingH12) {
                        Image(systemName: systemImage)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(tintColor)

                        Text(title)
                            .font(.appMedium14)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Spacer(minLength: 0)
                    }
                    .opacity(contentOpacity)
                    .padding(.horizontal, 20 * progress)
                    .frame(width: currentWidth, height: currentHeight)
                    .background(Color.black)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.3 * progress), radius: 12, x: 0, y: 6)
                    .position(x: geometry.size.width / 2, y: currentY)
                }
                .ignoresSafeArea(.all, edges: .top)
                .zIndex(999)
            }
        }
        .sensoryFeedback(.success, trigger: isPresented)
        .onChange(of: isPresented) { _, newValue in
            dismissTask?.cancel()

            if newValue {
                progress = 0
                contentOpacity = 0

                // Muncul: mulai kecil di island, jatuh + membesar bareng ke posisi akhir
                withAnimation(.interpolatingSpring(stiffness: 200, damping: 17)) {
                    progress = 1
                }
                withAnimation(.easeOut(duration: 0.25).delay(0.15)) {
                    contentOpacity = 1
                }

                dismissTask = Task {
                    try? await Task.sleep(nanoseconds: 2_500_000_000)
                    guard !Task.isCancelled else { return }

                    // Tahap 1: teks & ikon fade out duluan, lembut
                    withAnimation(.easeInOut(duration: 0.25)) {
                        contentOpacity = 0
                    }
                    try? await Task.sleep(nanoseconds: 150_000_000)
                    guard !Task.isCancelled else { return }

                    // Tahap 2: pill mengecil sambil naik balik ke titik island, halus
                    withAnimation(.timingCurve(0.4, 0, 0.2, 1, duration: 0.55)) {
                        progress = 0
                    }
                    try? await Task.sleep(nanoseconds: 550_000_000)
                    guard !Task.isCancelled else { return }
                    isPresented = false
                }
            }
        }
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}

extension View {
    func dynamicIslandToast(
        isPresented: Binding<Bool>,
        title: String,
        systemImage: String = "checkmark.circle.fill",
        tintColor: Color = .appSuccess
    ) -> some View {
        self.modifier(
            DynamicIslandToastModifier(
                isPresented: isPresented,
                title: title,
                systemImage: systemImage,
                tintColor: tintColor
            )
        )
    }
}
