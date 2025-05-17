//
//  ContentView.swift
//  G@C_MVP
//
//  Created by HARRISON TONG on 5/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = EmotionViewModel()
    var body: some View {
        VStack(spacing: 0) {
            EmotionCarouselCenteredView(viewModel: viewModel)
                .frame(height: 250) // 👈 give it more vertical space!

            Divider()

            ConversationTreeView(viewModel: viewModel)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 32) // 👈 give it space from the wheel
        }
        .padding()
    }
}
