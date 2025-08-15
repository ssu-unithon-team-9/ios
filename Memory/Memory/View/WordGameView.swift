//
//  WordGameView.swift
//  Memory
//
//  Created by 황채웅 on 8/13/25.
//

import SwiftUI

struct WordGameView: View {
    @StateObject var viewModel: WordGameViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
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
                
                Text("점수: \(viewModel.score)")
                    .font(.big32)
                
                
                // 피드백
                Text(viewModel.feedback)
                    .font(.title)
                    .foregroundColor(viewModel.feedbackColor)
                
                // 사용자 입력란
                HStack {
                    ForEach(viewModel.userInput, id: \.self) { input in
                        Text(input)
                            .font(.headline1)
                            .frame(width: 100, height: 100)
                            .padding(12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(24)
                    }
                }
                .padding()
                
                Spacer(minLength: 0)
                
                // 섞인 음절 버튼들
                HStack {
                    ForEach(viewModel.shuffledSyllables, id: \.self) { syllable in
                        Button(action: {
                            viewModel.handleTap(syllable: syllable)
                        }) {
                            Text(syllable)
                                .font(.headline1)
                                .foregroundStyle(.black)
                                .frame(maxWidth: 200)
                                .frame(height: 200)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                        }
                    }
                }.padding(.bottom, 100)
                
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.startGame()
        }
    }
}
