//
//  PictureReverseQuizView.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let imageData: Data
    var isFlipped: Bool = false
    var isMatched: Bool = false
    var borderColor: Color = .clear
}

class MemoryGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var showAll = true
    
    private var firstFlippedIndex: Int?
    private var matchedCount = 0
    
    private let columns = 4
    private let rows = 2
    private let previewTime: TimeInterval = 3
    
    init() {
        startGame()
    }
    
    func startGame() {
        Task {
            // 1. 이미지 데이터 미리 로딩
            let totalPairs = (columns * rows) / 2
            var imageDataList: [Data] = []
            
            for _ in 0..<totalPairs {
                if let url = URL(string: "https://picsum.photos/200"),
                   let data = try? Data(contentsOf: url) {
                    imageDataList.append(data)
                }
            }
            
            // 2. 쌍 만들고 셔플
            var newCards: [Card] = []
            for data in imageDataList {
                newCards.append(Card(imageData: data))
                newCards.append(Card(imageData: data))
            }
            newCards.shuffle()
            
            await MainActor.run {
                self.cards = newCards
                self.showAll = true
            }
            
            // 3. n초간 전체 공개
            try? await Task.sleep(nanoseconds: UInt64(previewTime * 1_000_000_000))
            await MainActor.run {
                self.showAll = false
                self.cards = self.cards.map { Card(imageData: $0.imageData) }
            }
        }
    }
    
    func flipCard(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
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
        if cards[firstIndex].imageData == cards[secondIndex].imageData {
            // 정답
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            cards[firstIndex].borderColor = .green
            cards[secondIndex].borderColor = .green
            matchedCount += 1
            
            // 모든 카드 맞춘 경우 다음 게임
            if matchedCount == cards.count / 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.startGame()
                }
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

struct MemoryGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(viewModel.cards) { card in
                CardView(card: card, showAll: viewModel.showAll)
                    .onTapGesture {
                        if !viewModel.showAll {
                            viewModel.flipCard(card)
                        }
                    }
            }
        }
        .padding()
    }
}

struct CardView: View {
    let card: Card
    let showAll: Bool
    
    var body: some View {
        ZStack {
            if card.isFlipped || showAll || card.isMatched {
                if let image = UIImage(data: card.imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
        .frame(width: 120, height: 120)
        .border(card.borderColor, width: 3)
        .cornerRadius(8)
    }
}
