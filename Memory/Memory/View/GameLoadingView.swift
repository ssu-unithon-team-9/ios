//
//  GameLoadingView.swift
//  Memory
//
//  Created by 황채웅 on 8/11/25.
//

import SwiftUI

struct GameLoadingView: View {
    
    let mainColor: Color
    let categoryTitle: String
    let title: String
    let timerSeconds: Int
    @State private var progress: CGFloat = 0.0
    
    init(mainColor: Color, categoryTitle: String, title: String, timerSeconds: Int) {
        self.mainColor = mainColor
        self.categoryTitle = categoryTitle
        self.title = title
        self.timerSeconds = timerSeconds
        Fonts.registerCustomFonts()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer(minLength: 0)
            VStack(alignment: .leading) {
                Text(categoryTitle)
                    .font(.headline4)
                    .foregroundStyle(.black)
                    .frame(width: 90, height: 44)
                    .background(mainColor)
                    .cornerRadius(22)
                    .overlay {
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.black, lineWidth: 1)
                            .padding(1)
                    }
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(title)
                    .font(.headline1)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer(minLength: 0)
            ZStack {
                Rectangle()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                    .cornerRadius(12)
                    .padding(.bottom, 24)
                Rectangle()
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                    .cornerRadius(12)
                    .padding(.trailing, (1.0 - progress) * UIScreen.main.bounds.width * 0.8)
                    .padding(.bottom, 24)
            }
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                    if progress < 1.0 {
                        progress += 0.001 / CGFloat(timerSeconds)
                    } else {
                        progress = 1.0
                    }
                }
                // Invalidate timer after timerSeconds
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(timerSeconds)) {
                    timer.invalidate()
                }
            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 28)
    }
}
#Preview {
    GameLoadingView(
        mainColor: .orange,
        categoryTitle: "기억력",
        title: "카드를 보고\n그림을 기억해\n뒤집힌 카드를\n짝지어 주세요",
        timerSeconds: 10
    )
}
