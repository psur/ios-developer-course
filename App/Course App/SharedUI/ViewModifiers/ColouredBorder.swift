//
//  ColouredBorder.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import SwiftUI

private struct ColouredBorder: ViewModifier {
    // MARK: - UI constant
    private enum UIConstant {
        static let shadowRadius: CGFloat = 2
        static let lineWidth: CGFloat = 2
    }

    // MARK: Public variables
    let color: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(.gray)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        color,
                        lineWidth: UIConstant.lineWidth
                    )
            )
            .shadow(radius: UIConstant.shadowRadius)
    }
}

extension View {
    func colouredBorder(color: Color, cornerRadius: CGFloat) -> some View {
        self.modifier(ColouredBorder(color: color, cornerRadius: cornerRadius))
    }
}
