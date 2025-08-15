//
//  TextColorQuiz.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import SwiftUI

final class TextColorQuiz: Equatable, Identifiable {
    static func == (lhs: TextColorQuiz, rhs: TextColorQuiz) -> Bool {
        lhs.incorrectColor == rhs.incorrectColor &&
        lhs.correctColor == rhs.correctColor
    }
    
    let description: String = "글자의 내용이 아닌,\n글자의 색깔을 맞혀주세요"
    let incorrectColor: Color // 빨강(텍스트가 나타내는 오답)
    let incorrectColorString: String // 빨강(오답 색 텍스트)
    let correctColor: String // 파란색(UI색, 정답)
    
    init(incorrectColor: Color, incorrectColorString: String, correctColor: String) {
        self.incorrectColor = incorrectColor
        self.incorrectColorString = incorrectColorString
        self.correctColor = correctColor
    }
}
