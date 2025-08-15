//
//  WordGameViewModel.swift
//  Memory
//
//  Created by 황채웅 on 8/13/25.
//

import Foundation
import Combine
import SwiftUI

class WordGameViewModel: ObservableObject {
    private let model = WordGameModel()
    
    @ObservedObject private var audioPlayer = AudioPlayer()
    
    @Published var currentWord: String = "" // 원본 단어 (비공개)
    @Published var shuffledSyllables: [String] = [] // 섞인 음절
    @Published var userInput: [String] = [] // 사용자 입력
    @Published var score: Int = 0
    @Published var timeRemaining: Double = 15
    @Published var feedback: String = "" // "정답" 또는 "오답"
    @Published var feedbackColor: Color = .clear // 초록 또는 빨강
    @Published var isGameOver: Bool = false
    
    var timer: AnyCancellable?
    var navigationPath: Binding<NavigationPath>
    let userId: Int
    
    init(navigationPath: Binding<NavigationPath>, userId: Int) {
        self.navigationPath = navigationPath
        self.userId = userId
    }
    
    func startGame() {
        resetGame()
        startTimer()
        nextQuestion()
    }
    
    private func resetGame() {
        score = 0
        timeRemaining = 15
        isGameOver = false
        feedback = ""
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 0.001, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 0.001
                } else {
                    self.endGame()
                }
            }
    }
    
    private func endGame() {
        timer?.cancel()
        isGameOver = true
        navigationPath.wrappedValue.removeLast(1)
        NetworkManager.shared.post(.saveGame(
            userId: userId,
            type: "LOGICAL",
            count: score > 30 ? 30 : score,
            totalCount: 30
        )) { (result: Result<String, Error>) in
            print("서버에 업로드 완료")
        }
        
    }
    
    func nextQuestion() {
        currentWord = model.getRandomWord()
        shuffledSyllables = model.shuffleSyllables(word: currentWord)
        userInput = []
        feedback = ""
    }
    
    func handleTap(syllable: String) {
        userInput.append(syllable)
        
        // 순서 체크: 입력 길이가 원본과 같을 때 최종 확인
        if userInput.count == currentWord.count {
            if model.checkAnswer(input: userInput, original: currentWord) {
                score += 1
                feedback = "정답"
                feedbackColor = .green
                audioPlayer.playSound(fileName: "correct")
            } else {
                feedback = "오답"
                feedbackColor = .red
                audioPlayer.playSound(fileName: "wrong")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.nextQuestion()
            }
        } else {
            // 중간 체크: 현재까지 입력이 원본과 맞는지 (순서 틀리면 즉시 오답)
            let originalSyllables = currentWord.map { String($0) }
            if !userInput.elementsEqual(originalSyllables.prefix(userInput.count)) {
                feedback = "오답"
                feedbackColor = .red
                audioPlayer.playSound(fileName: "wrong")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.nextQuestion()
                }
            }
        }
    }
}

import AVKit

class AudioPlayer: ObservableObject {
    var player: AVAudioPlayer?

    func playSound(fileName: String) {
        // Assets에서 MP3 파일 로드
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("\(fileName).mp3 파일을 찾을 수 없습니다.")
            return
        }

        do {
            // AVAudioPlayer 초기화
            player = try AVAudioPlayer(contentsOf: url)
            // 재생 준비
            player?.prepareToPlay()
            // 재생 시작
            player?.play()
        } catch {
            print("오디오 재생 오류: \(error.localizedDescription)")
        }
    }

    func stopSound() {
        // 재생 중지
        player?.stop()
    }
}
