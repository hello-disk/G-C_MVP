//
//  Emotion.swift
//  G@C_MVP
//
//  Created by HARRISON TONG on 5/14/25.
//

import Foundation

struct Emotion: Codable, Identifiable {
    let id: String
    let name: String
    let iconName: String
    let soundName: String
    let chord: String
    let responses: [ConversationBranch]
}

struct ConversationBranch: Codable {
    let text: String
    let subBranches: [String]
}
