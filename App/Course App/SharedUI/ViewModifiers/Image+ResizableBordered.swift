//
//  Image+ResizableBordered.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//

import SwiftUI

extension Image {
    func resizableBordered(cornerRadius: CGFloat = CornerRadiusSize.default.rawValue) -> some View {
        self
            .resizable()
            .scaledToFill()
            .colouredBorder(color: .white, cornerRadius: cornerRadius)
    }
}
