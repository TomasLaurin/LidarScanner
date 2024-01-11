//
//  NavigationViewDrawer.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 09.01.2024.
//

import SwiftUI

struct NavigationViewDrawer<Content: View>: View {
    @Binding var isOpen: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            if isOpen {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.5))
                    .onTapGesture {
                        isOpen = false
                    }
                    .ignoresSafeArea(.all)
            }

            VStack {
                Spacer()
                self.content()
            }
            .background(Color.white)
            .frame(width: min(geometry.size.width * 0.75, 300))
            .offset(x: self.isOpen ? 0 : geometry.size.width)
        }
    }
}
