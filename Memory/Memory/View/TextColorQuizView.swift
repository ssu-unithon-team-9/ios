//
//  TextColorQuizView.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import SwiftUI

struct TextColorQuizView: View {
    @StateObject private var viewModel: TextColorQuizViewModel
    
    // 사용 가능한 색상 목록 (색상 이름 -> Color 변환용)
    private let availableColors: [(color: Color, name: String)] = [
        (.red, "빨강"),
        (.blue, "파랑"),
        (.green, "초록"),
        (.yellow, "노랑"),
        (.purple, "보라"),
        (.orange, "주황"),
        (.pink, "핑크"),
        (.gray, "회색"),
        (.cyan, "청록")
    ]
    
    // 한국어 색상 이름을 SwiftUI Color로 변환
    private func color(from name: String) -> Color {
        availableColors.first { $0.name == name }?.color ?? .blue
    }
    
    init(viewModel: TextColorQuizViewModel = TextColorQuizViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.state.quiz.description)
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            // 퀴즈 설명 TTS 뷰
            QuizTTSView(text: viewModel.state.quiz.description)
            // 퀴즈 텍스트 (오답 색상 이름, 정답 색상으로 표시)
            Text(viewModel.state.quiz.incorrectColorString)
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(color(from: viewModel.state.quiz.correctColor))
            Spacer(minLength: 0)
            // 3x3 그리드
            HStack(spacing: 8) {
                ForEach(0..<3) { col in
                    VStack(spacing: 8) {
                        ForEach(0..<3) { row in
                            let index = col * 3 + row
                            if index < viewModel.state.buttonColors.count {
                                Button(action: {
                                    viewModel.action(.selectColor(viewModel.state.buttonColors[index].name))
                                    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            viewModel.action(.generateNewQuiz)
                                        }
                                }) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(viewModel.state.buttonColors[index].color)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1, contentMode: .fit)
                                        .overlay {
                                            if viewModel.state.showFeedback,
                                               let isCorrect = viewModel.state.isCorrect,
                                               viewModel.state.buttonColors[index].name == viewModel.state.quiz.correctColor {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(isCorrect ? Color.green : Color.red, lineWidth: 4)
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
            VStack {
                // 정답 여부 피드백
                if viewModel.state.showFeedback, let isCorrect = viewModel.state.isCorrect {
                    Text(isCorrect ? "정답입니다!" : "오답입니다.")
                        .foregroundStyle(isCorrect ? .green : .red)
                    
                }
            }.frame(height: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}
