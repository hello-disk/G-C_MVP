//
//  EmotionDataLoader.swift
//  G@C_MVP
//
//  Created by HARRISON TONG on 5/14/25.
//

import Foundation

class EmotionDataLoader {
    static func loadEmotions() -> [Emotion] {
        guard let url = Bundle.main.url(forResource: "emotions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ Failed to load emotions.json")
            return []
        }

        let decoder = JSONDecoder()
        return (try? decoder.decode([Emotion].self, from: data)) ?? []
    }
}
