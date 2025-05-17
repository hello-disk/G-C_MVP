import SwiftUI

struct EmotionCarouselCenteredView: View {
    @ObservedObject var viewModel: EmotionViewModel
    @State private var currentCenterEmotionID: String?
    @State private var emotionOffsets: [String: CGFloat] = [:]

    var body: some View {
        GeometryReader { fullGeo in
            let lockX = fullGeo.size.width / 2

            ZStack {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            Spacer().frame(width: lockX - 50) // Left padding for center alignment

                            ForEach(viewModel.emotions) { emotion in
                                GeometryReader { itemGeo in
                                    let itemMidX = itemGeo.frame(in: .global).midX
                                    let distance = abs(itemMidX - fullGeo.frame(in: .global).midX)
                                    let scale = max(1.0 - (distance / 300), 0.75)
                                    let opacity = max(1.0 - (distance / 300), 0.4)
                                    let yOffset = -sin((itemMidX - lockX) / fullGeo.size.width * .pi) * 20

                                    EmotionWheelItem(
                                        emotion: emotion,
                                        selectedEmotion: viewModel.selectedEmotion,
                                        onTap: {
                                            scrollTo(emotion: emotion, proxy: proxy)
                                            viewModel.selectedEmotion = emotion
                                            viewModel.playSound(for: emotion)
                                            viewModel.triggerHaptic()
                                        }
                                    )
                                    .scaleEffect(scale)
                                    .opacity(opacity)
                                    .offset(x: 0, y: yOffset)
                                    .onAppear {
                                        emotionOffsets[emotion.id] = itemMidX
                                    }
                                    .onChange(of: itemMidX) { newValue in
                                        emotionOffsets[emotion.id] = newValue
                                        if isLocked(midX: newValue, lockX: lockX) &&
                                            currentCenterEmotionID != emotion.id {
                                            currentCenterEmotionID = emotion.id
                                            viewModel.selectedEmotion = emotion
                                            viewModel.triggerHaptic()
                                        }
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .id(emotion.id)
                            }

                            Spacer().frame(width: lockX - 50)
                        }
                    }
                    .frame(width: fullGeo.size.width, height: 100)
                    .gesture(
                        DragGesture().onEnded { _ in
                            if let closest = closestEmotion(to: lockX) {
                                scrollTo(emotion: closest, proxy: proxy)
                                viewModel.selectedEmotion = closest
                                viewModel.playSound(for: closest)
                                viewModel.triggerHaptic()
                            }
                        }
                    )
                }
            }
            .frame(width: fullGeo.size.width, height: fullGeo.size.height, alignment: .top)
            .offset(y: fullGeo.size.height / 2 - 100) // instead of -60
        }
    }

    private func isLocked(midX: CGFloat, lockX: CGFloat) -> Bool {
        abs(midX - lockX) < 40
    }

    private func closestEmotion(to centerX: CGFloat) -> Emotion? {
        viewModel.emotions.min(by: {
            abs((emotionOffsets[$0.id] ?? .infinity) - centerX) <
            abs((emotionOffsets[$1.id] ?? .infinity) - centerX)
        })
    }

    private func scrollTo(emotion: Emotion, proxy: ScrollViewProxy) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            proxy.scrollTo(emotion.id, anchor: .center)
        }
    }
}
