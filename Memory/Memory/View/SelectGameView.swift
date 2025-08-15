//
//  SelectGameView.swift
//  Memory
//
//  Created by 황채웅 on 8/12/25.
//

import SwiftUI

struct SelectGameView: View {
    
    @Binding var navigationPath: NavigationPath
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text(formattedDate())
                    .font(.subtitle1)
                    .foregroundStyle(.gray)
                Text("오늘의 인지력 퀴즈")
                    .font(.headline4)
                    .foregroundStyle(.black)
            }
            .padding(.bottom, 12)
            GameButton(mainColor: .gameOrange, image: .iconCard, title: "카드 짝 맞추기", subtitle: "기억력 퀴즈")
                .onTapGesture {
                    navigationPath.append("loadingCardGame")
                    Task {
                        try await TTSManager.shared.textToSpeech(text: "카드를 보고\n그림을 기억해\n뒤집힌 카드를\n짝지어 주세요", voice: .HanAim)
                    }
                }
            GameButton(mainColor: .gameGreen, image: .iconPalette, title: "색깔 맞히기", subtitle: "주의력/반응속도 퀴즈")
                .onTapGesture {
                    navigationPath.append("loadingColorGame")
                    Task {
                        try await TTSManager.shared.textToSpeech(text: "글자의 내용이\n아닌,\n글자의 색깔을\n맞혀주세요", voice: .HanAim)
                    }
                }
            GameButton(mainColor: .gameBlue, image: .iconSentence, title: "낱말 결합", subtitle: "논리력/언어 퀴즈")
                .onTapGesture {
                    navigationPath.append("loadingSentenceGame")
                    Task {
                        try await TTSManager.shared.textToSpeech(text: "섞인 낱말을\n올바른 순서로\n배열하세요", voice: .HanAim)
                    }
                }
        }
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        return formatter.string(from: Date())
    }
}

private struct GameButton: View {
    
    let mainColor: Color
    let image: ImageResource
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(image)
                .resizable()
                .frame(width: 40*2, height: 40*2)
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle)
                    .font(.big36)
                    .foregroundStyle(mainColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(title)
                    .font(.big40)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(.white)
        .cornerRadius(24)
        .shadow(color: Color(white: 0.85), radius: 24, x: 4, y: 4)
        .padding(.horizontal, 24)
    }
}
