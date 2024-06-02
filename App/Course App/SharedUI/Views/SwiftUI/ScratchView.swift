//
//  ScratchView.swift
//  Course App
//
//  Created by Peter Surovy on 02.06.2024.
//


import SwiftUI

struct ScratchView: View {
    // MARK: - Line
    private struct Line {
        var points = [CGPoint]()
    }

    // MARK: - UIConstant
    private enum UIConstant {
        static let lineWidth: Double = 50.0
    }

    // MARK: Public variables
    let image: Image
    let text: String

    // MARK: Private variables
    @State private var currentLine = Line()
    @State private var lines = [Line]()

    var body: some View {
        ZStack(alignment: .top) {
            image
                .resizableBordered()
                .scaledToFit()

            RoundedRectangle(cornerRadius: CornerRadiusSize.default.rawValue)
                .fill(.bg)
                .overlay {
                    Text(text)
                        .textStyle(textType: .baseText)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .mask(
                    Canvas { context, _ in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(
                                path,
                                with: .color(.white),
                                style: StrokeStyle(
                                    lineWidth: UIConstant.lineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        }
                    }
                )
                .gesture(dragGesture)
        }
    }

    // MARK: Drag gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                currentLine.points.append(value.location)
                lines.append(currentLine)
            }
    }
}

#Preview {
    ScratchView(image: Image("nature"), text: "Joke")
}
