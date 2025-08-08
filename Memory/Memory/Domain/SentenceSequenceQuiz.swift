//
//  SentenceSequenceQuiz.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import Foundation

final class SentenceSequenceQuiz: Equatable, Identifiable {
    static func == (lhs: SentenceSequenceQuiz, rhs: SentenceSequenceQuiz) -> Bool {
        lhs.originalSentence == rhs.originalSentence
    }
    
    let description: String = "단어의 순서를 올바르게 배열하세요"
    let originalSentence: [String]
    let shuffledSentence: [String]
    
    init(originalSentence: [String], shuffledSentence: [String]) {
        self.originalSentence = originalSentence
        self.shuffledSentence = shuffledSentence
    }
}
