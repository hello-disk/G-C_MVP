import SwiftUI

struct ConversationTreeView: View {
    @ObservedObject var viewModel: EmotionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let emotion = viewModel.selectedEmotion {
                Text(emotion.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                    .foregroundColor(.primary)

                ForEach(emotion.responses, id: \.text) { response in
                    Button(action: {
                        viewModel.selectedResponse = response
                    }) {
                        Text("→ \(response.text)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(12)
                    }
                }

                if let subResponses = viewModel.selectedResponse?.subBranches {
                    ForEach(subResponses, id: \.self) { sub in
                        Button(action: {
                            viewModel.selectedSubResponse = sub
                            viewModel.playChord(for: emotion)

                            // 🔊 Speak full sentence
                            let sentence = "\(emotion.name): \(viewModel.selectedResponse?.text ?? "") \(sub)"
                            viewModel.speak(sentence)
                        }) {
                            Text("• \(sub)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.green.opacity(0.15))
                                .cornerRadius(8)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: subResponses)
                    }
                }
            } else {
                Text("Pick an emotion to start.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding()
    }
}
