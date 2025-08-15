//
//  TextColorQuizViewModel.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import Foundation
import SwiftUI

class TextColorQuizViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var state: TextColorQuizState
    @Published var timeRemaining: Double = 15.0  // 남은 시간 (초 단위)
    @Published var isGameOver: Bool = false  // 게임 종료 상태
    @Published var correctCount: Int = 0  // 맞춘 문제 수 (누적)
    
    private let useCase: GenerateTextColorQuizUseCase
    private var timer: Timer?
    private let gameDuration: Double = 15.0  // 게임 제한 시간 (초)
    
    var navigationPath: Binding<NavigationPath>
    private let userId: Int
    
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
    init(useCase: GenerateTextColorQuizUseCase = GenerateTextColorQuizUseCase(),
         navigationPath: Binding<NavigationPath>, userId: Int) {
        self.userId = userId
        self.useCase = useCase
        self.navigationPath = navigationPath
        let initialQuiz = useCase.execute()
        self.state = TextColorQuizState(
            quiz: initialQuiz,
            buttonColors: [],
            isCorrect: nil,
            showFeedback: false
        )
        self.state.buttonColors = generateButtonColors(for: initialQuiz)
        startTimer()  // 초기화 시 타이머 시작
    }
    
    // MARK: - ViewModelable
    func action(_ action: TextColorQuizAction) {
        guard !isGameOver else { return }
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
        if isCorrect {
            correctCount += 1
        }
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
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 0.001
            } else {
                self.stopTimer()
                self.endGame()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func endGame() {
        isGameOver = true
        print("게임 종료! 맞춘 문제 수: \(correctCount)")
        navigationPath.wrappedValue.removeLast(1)
        NetworkManager.shared.post(.saveGame(
            userId: userId,
            type: "ATTENTION",
            count: correctCount > 20 ? 20 : correctCount,
            totalCount: 20
        )) { (result: Result<String, Error>) in
            print("서버에 업로드 완료")
        }
    }
}
