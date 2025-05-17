//
//  HapticScrollDetector.swift
//  G@C_MVP
//
//  Created by HARRISON TONG on 5/14/25.
//

import SwiftUI

struct HapticScrollDetector: View {
    @ObservedObject var viewModel: EmotionViewModel
    let emotions: [Emotion]
    
    @State private var currentTopEmotionID: String?

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    ForEach(emotions) { emotion in
                        GeometryReader { itemGeo in
                            EmotionWheelItem(
                                emotion: emotion,
                                selectedEmotion: viewModel.selectedEmotion,
                                onTap: {
                                    viewModel.selectedEmotion = emotion
                                    viewModel.playSound(for: emotion)
                                }
                            )
                            .frame(width: itemGeo.size.width, height: 100)
                            .onAppear {
                                // preload haptic engine
                                UIImpactFeedbackGenerator(style: .medium).prepare()
                            }
                            .onChange(of: isEmotionAtTop(itemGeo: itemGeo, fullGeo: geo, emotion: emotion)) { isAtTop in
                                if isAtTop && currentTopEmotionID != emotion.id {
                                    currentTopEmotionID = emotion.id
                                    viewModel.selectedEmotion = emotion
                                    viewModel.triggerHaptic()
                                }
                            }
                        }
                        .frame(height: 100)
                    }
                }
                .padding(.top, geo.size.height / 3)
                .padding(.bottom, geo.size.height / 2)
            }
        }
    }

    // Helper to detect topmost emotion
    private func isEmotionAtTop(itemGeo: GeometryProxy, fullGeo: GeometryProxy, emotion: Emotion) -> Bool {
        let itemMidY = itemGeo.frame(in: .global).midY
        let topY = fullGeo.frame(in: .global).minY + 100
        return abs(itemMidY - topY) < 40 // within a small threshold
    }
}
