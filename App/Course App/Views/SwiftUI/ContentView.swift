//
//  ContentView.swift
//  Course App
//
//  Created by Peter Surovy on 27.04.2024.
//

import SwiftUI
import os

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Peter!")
        }
        .padding()
        .onAppear(){
            let logger = Logger()
            logger.info("The view is appearing")
        }
    }
}

#Preview {
    ContentView()
}
