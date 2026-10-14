//
//  Space+Extension.swift
//  TravPal
//
//  Created by Revan Arturito on 04/09/26.
//

import SwiftUI

struct VSpace: View {
    let height: CGFloat
    
    init(_ height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        Spacer()
            .frame(height: height)
    }
}

struct HSpace: View {
    let width: CGFloat
    
    init(_ width: CGFloat) {
        self.width = width
    }
    
    var body: some View {
        Spacer()
            .frame(width: width)
    }
}
