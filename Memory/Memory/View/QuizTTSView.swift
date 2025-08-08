//
//  QuizTTSView.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import SwiftUI

struct QuizTTSView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Button(
                action: {
                    Task {
                        try await TTSManager.shared.textToSpeech(text: text, voice: .ChungMan)
                    }
                }, label: {
                    Text("읽기")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(.gray)
                        .cornerRadius(20)
                }
            )
        }
    }
}
