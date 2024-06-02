//
//  SelectableButtonStyle.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import SwiftUI

struct SelectableButtonStyle: ButtonStyle {
    // MARK: - UI constants
    private enum StyleConstant {
        static let opacity: CGFloat = 0.5
        static let scaleEffectMin: CGFloat = 0.7
        static let scaleEffectMax: CGFloat = 1
    }

    // MARK: Public variables
    @Binding var isSelected: Bool
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(PaddingSize.default.rawValue)
            .background(color.opacity(StyleConstant.opacity))
            .foregroundColor(isSelected ? .red : .white)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusSize.default.rawValue))
            .scaleEffect(configuration.isPressed ? StyleConstant.scaleEffectMin : StyleConstant.scaleEffectMax)
            .animation(.easeInOut, value: isSelected)
            .animation(.easeInOut, value: configuration.isPressed)
            .contentShape(Rectangle())
    }
}
