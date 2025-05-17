//
//  EmotionWheelItem.swift
//  G@C_MVP
//
//  Created by HARRISON TONG on 5/14/25.
//

import SwiftUI

struct EmotionWheelItem: View {
    let emotion: Emotion
    let selectedEmotion: Emotion?
    let onTap: () -> Void

    var isSelected: Bool {
        selectedEmotion?.id == emotion.id
    }

    var body: some View {
        Button(action: onTap) {
            Image(emotion.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: isSelected ? 100 : 70, height: isSelected ? 100 : 70)
                .opacity(isSelected ? 1.0 : 0.5)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .shadow(color: isSelected ? .yellow.opacity(0.4) : .clear, radius: 12)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        }
    }
}

