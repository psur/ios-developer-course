//
//  SwipingView.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import os
import SwiftUI

struct SwipingView: View {
    // MARK: - UIConstant
    private enum UIConstant {
        static let padding: CGFloat = 20
        static var cardWidthPadding: CGFloat {
            padding + padding
        }
        static let scale: CGFloat = 1.5
    }
    // MARK: Private variables
    private let dataProvider = MockDataProvider()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let category = dataProvider.data.first {
                    ZStack {
                        ForEach(category.jokes, id: \.self) { joke in
                            SwipingCard(
                                configuration: SwipingCard.Configuration(
                                    image: Image(uiImage: joke.image ?? UIImage()),
                                    title: category.title,
                                    description: joke.text
                                ),
                                swipeStateAction: { _ in }
                            )
                        }
                    }
                    .padding(.leading, UIConstant.padding)
                    .padding(.trailing, UIConstant.padding)
                    .padding(.top, UIConstant.cardWidthPadding)
                    .frame(
                        width: geometry.size.width - UIConstant.cardWidthPadding,
                        height: (geometry.size.width - UIConstant.cardWidthPadding) * UIConstant.scale
                    )
                } else {
                    Text("Empty data!")
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle("Random jokes")
        .embedInScrollViewIfNeeded()
    }
}

#Preview {
    SwipingView()
}
