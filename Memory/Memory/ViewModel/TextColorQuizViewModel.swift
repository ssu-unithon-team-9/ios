//
//  TextColorQuizViewModel.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import Foundation
import SwiftUI

class TextColorQuizViewModel: ViewModelable {
    // MARK: - Properties
    @Published private(set) var state: TextColorQuizState
    private let useCase: GenerateTextColorQuizUseCase
    
    // 뷰모델 상태 정의
    struct TextColorQuizState {
        var quiz: TextColorQuiz
        var buttonColors: [(color: Color, name: String)]
        var isCorrect: Bool?
        var showFeedback: Bool
    }

    // 뷰모델 액션 정의
    enum TextColorQuizAction {
        case selectColor(String)
        case generateNewQuiz
    }

    
    // 사용 가능한 색상 목록
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
    
    // MARK: - Initialization
    init(useCase: GenerateTextColorQuizUseCase = GenerateTextColorQuizUseCase()) {
        self.useCase = useCase
        let initialQuiz = useCase.execute()
        self.state = TextColorQuizState(
            quiz: initialQuiz,
            buttonColors: [],
            isCorrect: nil,
            showFeedback: false
        )
        self.state.buttonColors = generateButtonColors(for: initialQuiz)
    }
    
    // MARK: - ViewModelable
    func action(_ action: TextColorQuizAction) {
        switch action {
        case .selectColor(let colorName):
            handleColorSelection(colorName)
        case .generateNewQuiz:
            generateNewQuiz()
        }
    }
    
    // MARK: - Private Methods
    private func generateButtonColors(for quiz: TextColorQuiz) -> [(color: Color, name: String)] {
        var colors = availableColors.filter { $0.name != quiz.correctColor }
        colors.shuffle()
        colors = Array(colors.prefix(8))
        let correctColorPair = availableColors.first { $0.name == quiz.correctColor } ?? (.blue, quiz.correctColor)
        colors.append(correctColorPair)
        return colors.shuffled()
    }
    
    private func handleColorSelection(_ colorName: String) {
        let isCorrect = colorName == state.quiz.correctColor
        state = TextColorQuizState(
            quiz: state.quiz,
            buttonColors: state.buttonColors,
            isCorrect: isCorrect,
            showFeedback: true
        )
    }
    
    private func generateNewQuiz() {
        let newQuiz = useCase.execute()
        state = TextColorQuizState(
            quiz: newQuiz,
            buttonColors: generateButtonColors(for: newQuiz),
            isCorrect: nil,
            showFeedback: false
        )
    }
}
