//
//  ViewExtension.swift
//  LidarScanner
//
//  Created by Tomáš Laurin on 11.01.2024.
//

import SwiftUI


// MARK: Name view extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
