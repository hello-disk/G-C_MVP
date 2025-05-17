//
//  EmotionViewModel.swift
//  G@C_MVP
//
//  Created by HARRISON TONG on 5/14/25.
//

import Foundation
import AVFoundation
// At the top of the file
import UIKit // for haptics



class EmotionViewModel: ObservableObject {
    @Published var emotions: [Emotion] = []
    @Published var selectedEmotion: Emotion?
    @Published var selectedResponse: ConversationBranch?
    @Published var selectedSubResponse: String?
    @Published var chordIndex: Int = 0

    private let speechSynthesizer = AVSpeechSynthesizer()
    private var audioPlayer: AVAudioPlayer?

    let chordProgressions: [String: [String]] = [
        "happy": ["Cmaj7", "Fmaj7", "G7"],
        "sad": ["Amin", "Dmin", "E7"],
        "mad": ["Dmin", "Gmin", "A7"],
        "scared": ["F#dim", "Bmin", "C#7"],
        "tired": ["Ebmaj7", "Abmaj7", "Bb7"],
        "love": ["Gmaj", "Cmaj7", "D7"],
        "curious": ["Bmaj7", "Emaj7", "F#7"]
    ]

    init() {
        emotions = EmotionDataLoader.loadEmotions()
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        
        // 🗣️ Choose a natural-sounding voice
        if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact") {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        // 🎚️ Natural pacing
        utterance.pitchMultiplier = 1.1  // slightly expressive
        utterance.rate = 0.42            // slower than default
        utterance.volume = 0.95

        speechSynthesizer.speak(utterance)
    } 
    
    
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func playSound(for emotion: Emotion) {
        if let url = Bundle.main.url(forResource: emotion.soundName, withExtension: nil) {
            print("Playing sound from:", url) // for debugging
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error loading sound: \(error)")
            }
        } else {
            print("❌ Sound file not found:", emotion.soundName)
        }
    }
    

    func playChord(for emotion: Emotion) {
        guard let progression = chordProgressions[emotion.id.lowercased()] else { return }

        let chordName = progression[chordIndex % progression.count]
        chordIndex += 1

        if let url = Bundle.main.url(forResource: chordName, withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } else {
            print("⚠️ Missing audio file for: \(chordName)")
        }
    }

    func resetChordProgression() {
        chordIndex = 0
    }
}
