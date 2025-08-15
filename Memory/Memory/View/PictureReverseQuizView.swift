//
//  PictureReverseQuizView.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import SwiftUI

// Model: Card 구조체는 게임의 카드 데이터를 나타냅니다.
// Domain Layer에 속하는 Entity로, 게임 도메인의 핵심 데이터를 캡슐화합니다.
struct Card: Identifiable {
    let id = UUID()
    let emoji: String  // 이미지 데이터 대신 이모지 문자열 사용
    var isFlipped: Bool = false
    var isMatched: Bool = false
    var borderColor: Color = .clear
}

// ViewModel: 게임 로직을 처리하며, MVVM 패턴에 따라 View와 분리됩니다.
// Clean Architecture 관점에서, ViewModel은 Presentation Layer에 속하며, Domain Layer의 Use Case를 호출하여 비즈니스 로직을 실행합니다.
// 여기서는 간단한 게임이므로 ViewModel 내에서 타이머와 스코어 로직을 직접 처리하지만, 복잡한 앱에서는 별도의 Use Case로 분리할 수 있습니다.
class MemoryGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var showAll = true
    @Published var timeRemaining: Double = 15  // 남은 시간 (초 단위)
    @Published var isGameOver: Bool = false  // 게임 종료 상태
    @Published var matchedCount: Int = 0  // 총 맞춘 쌍 수 (누적 스코어)
    
    private var currentMatched: Int = 0  // 현재 세트에서 맞춘 쌍 수 (각 게임 초기화)
    
    var navigationPath: Binding<NavigationPath>
    
    private var firstFlippedIndex: Int?
    private var timer: Timer?  // 타이머 인스턴스
    
    private let userId: Int
    private let columns = 4
    private let rows = 2
    private let previewTime: TimeInterval = 3
    private let gameDuration: Double = 15  // 게임 제한 시간 (초)
    
    // 가능한 이모지 목록 (랜덤으로 선택하기 위해 배열로 정의)
    private let emojis = ["😀", "😎", "🥳", "🤖", "🚀", "🌟", "🍎", "🍌", "🐶", "🐱", "🌈", "🎉"]
    
    init(navigationPath: Binding<NavigationPath>, userId: Int) {
        self.userId = userId
        self.navigationPath = navigationPath
        startGame()
    }
    
    func startGame() {
        stopTimer()  // 새로운 게임 시작 시 기존 타이머 멈춤
        
        let totalPairs = (columns * rows) / 2
        var selectedEmojis: [String] = []
        
        // 랜덤 이모지 쌍 생성: emojis 배열에서 랜덤으로 totalPairs만큼 선택
        var shuffledEmojis = emojis.shuffled()
        for _ in 0..<totalPairs {
            if let emoji = shuffledEmojis.popLast() {
                selectedEmojis.append(emoji)
            }
        }
        
        // 쌍 만들고 셔플
        var newCards: [Card] = []
        for emoji in selectedEmojis {
            newCards.append(Card(emoji: emoji))
            newCards.append(Card(emoji: emoji))
        }
        newCards.shuffle()
        
        DispatchQueue.main.async {
            self.cards = newCards
            self.showAll = true
            // timeRemaining 초기화 제거: 기존 남은 시간 유지
            self.currentMatched = 0  // 현재 세트 맞춘 수 초기화
            self.isGameOver = false
        }
        
        // n초간 전체 공개
        DispatchQueue.main.asyncAfter(deadline: .now() + self.previewTime) {
            self.showAll = false
            self.cards = self.cards.map { Card(emoji: $0.emoji) }
            self.startTimer()  // 미리보기 후 타이머 시작 (기존 남은 시간에서 재개)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 0.001
            } else {
                self.stopTimer()
                self.endGame(success: false)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func endGame(success: Bool) {
        isGameOver = true
        print("게임 종료! 맞춘 쌍 수: \(matchedCount)")  // 스코어 출력 (누적 점수)
        // MVVM-C에서 Coordinator를 통해 다음 화면으로 이동할 수 있지만, 여기서는 간단히 print로 처리
        // 성공 시 (모든 쌍 맞춤) 새로운 게임 자동 시작, 실패 시 (시간 종료) 이전 화면으로
        if self.timeRemaining <= 0 {
            self.navigationPath.wrappedValue.removeLast(1)
            NetworkManager.shared.post(.saveGame(
                userId: userId,
                type: "MEMORY",
                count: matchedCount > 10 ? 10 : matchedCount,
                totalCount: 10
            )) { (result: Result<String, Error>) in
                print("서버에 업로드 완료")
            }
        }
        //FIXME:
        if success {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  // 2초 후 자동 재시작
                self.startGame()
            }
        }
    }
    
    func flipCard(_ card: Card) {
        guard !isGameOver,
              let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].isFlipped,
              !cards[index].isMatched else { return }
        
        cards[index].isFlipped = true
        
        if let firstIndex = firstFlippedIndex {
            checkMatch(firstIndex: firstIndex, secondIndex: index)
            firstFlippedIndex = nil
        } else {
            firstFlippedIndex = index
        }
    }
    
    private func checkMatch(firstIndex: Int, secondIndex: Int) {
        if cards[firstIndex].emoji == cards[secondIndex].emoji {
            // 정답
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            cards[firstIndex].borderColor = .green
            cards[secondIndex].borderColor = .green
            matchedCount += 1
            currentMatched += 1
            
            // 모든 카드 맞춘 경우 (타이머 무시하고 종료)
            if currentMatched == cards.count / 2 {
                stopTimer()
                endGame(success: true)
            }
        } else {
            // 오답
            cards[firstIndex].borderColor = .red
            cards[secondIndex].borderColor = .red
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cards[firstIndex].isFlipped = false
                self.cards[secondIndex].isFlipped = false
                self.cards[firstIndex].borderColor = .clear
                self.cards[secondIndex].borderColor = .clear
            }
        }
    }
}

// View: UI를 렌더링하며, ViewModel을 관찰합니다.
// MVVM-C에서 Coordinator는 navigation을 처리하지만, 이 간단한 게임에서는 별도의 Coordinator 없이 ViewModel에서 게임 종료를 처리합니다.
// View는 Presentation Layer의 일부로, 상태 변화에 따라 UI를 업데이트합니다.
struct MemoryGameView: View {
    @StateObject var viewModel: MemoryGameViewModel
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .cornerRadius(12)
                        .padding(.bottom, 24)
                    Rectangle()
                        .foregroundStyle(.gameOrange)
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .cornerRadius(12)
                        .padding(.trailing, (geo.size.width - 48)  * (1 - viewModel.timeRemaining / 15))
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
                Text("카드를 보고 그림을 기억해,\n뒤집힌 카드를 짝지어 주세요")
                    .font(.headline2)
                    .multilineTextAlignment(.center)
                    .padding()
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.cards) { card in
                        MemoryCardView(card: card, showAll: viewModel.showAll)
                            .onTapGesture {
                                if !viewModel.showAll {
                                    viewModel.flipCard(card)
                                }
                            }
                    }
                }
                .padding()
                .disabled(viewModel.isGameOver)  // 게임 종료 시 탭 비활성화
                Text("점수: \(viewModel.matchedCount)")
                    .font(.headline4)
                    .foregroundColor(.red)
            }
        }
    }
}

// 카드 뷰: 이모지를 표시하도록 변경
struct MemoryCardView: View {
    let card: Card
    let showAll: Bool
    
    var body: some View {
        ZStack {
            if card.isFlipped || showAll || card.isMatched {
                Text(card.emoji)
                    .font(.system(size: 60))  // 이모지 크기 조정
            } else {
                Rectangle()
                    .fill(.gameOrange)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .border(card.borderColor, width: 3)
        .cornerRadius(8)
    }
}
