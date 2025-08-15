//
//  WordGameModel.swift
//  Memory
//
//  Created by 황채웅 on 8/13/25.
//

import Foundation
// WordGameModel.swift
struct WordGameModel {
    let words: [String] = [
        "사과나무", "바나나빵", "노트북", "자전거길", "텔레비전", "스마트폰",
        "공기놀이", "손목시계", "책상다리", "안락의자", "창문틀", "현관문",
        "공기놀이", "연필심", "지우개", "배낭가방", "운동화", "외투옷",
        "야구모자", "안경테", "양산우산", "거울방", "냉장고", "전자레인지",
        "소파커버", "침대프레임", "베개커버", "이불덮개", "목욕수건", "액체비누",
        "샴푸병", "치약튜브", "칫솔대", "유리컵", "접시더미", "숟가락",
        "젓가락", "종이가위", "부엌칼", "종이뭉치", "볼펜심", "마커펜",
        "테이프", "풀바른", "책상서랍", "스탠드램프", "전구소켓", "배터리팩",
        "충전케이블", "휴대폰케이스", "이어폰줄"
    ]
    
    func getRandomWord() -> String {
        words.randomElement() ?? "사과"
    }
    
    func shuffleSyllables(word: String) -> [String] {
        let syllables = word.map { String($0) } // 한글 음절 단위로 분리 (한글은 유니코드상 음절이 단위)
        return syllables.shuffled()
    }
    
    func checkAnswer(input: [String], original: String) -> Bool {
        let originalSyllables = original.map { String($0) }
        return input == originalSyllables
    }
}
