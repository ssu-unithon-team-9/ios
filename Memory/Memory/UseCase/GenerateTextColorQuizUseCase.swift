//
//  GenerateTextColorQuizUseCase.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import SwiftUI

// 퀴즈 생성 유즈케이스
struct GenerateTextColorQuizUseCase {
    // 사용 가능한 색상 목록 (색상과 한국어 이름 쌍)
    private let availableColors: [(color: Color, name: String)]
    
    // 초기화 시 색상 목록 주입
    init(availableColors: [(color: Color, name: String)] = [
        (.red, "빨강"),
        (.blue, "파랑"),
        (.green, "초록"),
        (.yellow, "노랑"),
        (.purple, "보라"),
        (.orange, "주황"),
        (.pink, "핑크"),
        (.gray, "회색"),
        (.cyan, "청록")
    ]) {
        self.availableColors = availableColors
    }
    
    // 새로운 퀴즈 생성
    func execute() -> TextColorQuiz {
        // 색상 목록을 무작위로 섞기
        let shuffledColors = availableColors.shuffled()
        
        // 오답 색상과 정답 색상 선택 (서로 달라야 함)
        let incorrectColorPair = shuffledColors[0]
        let correctColorPair = shuffledColors.first { $0.name != incorrectColorPair.name } ?? shuffledColors[1]
        
        return TextColorQuiz(
            incorrectColor: incorrectColorPair.color,
            incorrectColorString: incorrectColorPair.name,
            correctColor: correctColorPair.name
        )
    }
}
