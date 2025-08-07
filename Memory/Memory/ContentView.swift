//
//  ContentView.swift
//  Memory
//
//  Created by 황채웅 on 8/7/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var isOpened: Bool = false
    @State var selectedIndex: Int?
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(.apple)
                .frame(width: 200, height: 200)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Text("해당 과일의 이름을 고르시오.")
                .font(.title)
                .foregroundStyle(.black)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 8) {
                AnswerButton(
                    text: "바나나",
                    action: {
                        print("1번 클릭")
                        isOpened.toggle()
                        selectedIndex = 0
                    },
                    isCorrect: false,
                    isSelected: selectedIndex == 0,
                    isOpened: isOpened
                )
                AnswerButton(
                    text: "사과",
                    action: {
                        print("2번 클릭")
                        isOpened.toggle()
                        selectedIndex = 1
                    },
                    isCorrect: true,
                    isSelected: selectedIndex == 1,
                    isOpened: isOpened
                )
            }
            .frame(width: .infinity ,height: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 20)
    }
}

private struct AnswerButton: View {
    
    let text: String
    let action: () -> Void
    let isCorrect: Bool // 정답 여부
    let isSelected: Bool // 선택 여부
    let isOpened: Bool // 오픈 여부
    
    var body: some View {
        Button(
            action: {
                action()
            }, label: {
                Text(text)
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .background(
                        isOpened
                        && isSelected
                        ? (isCorrect ? .green : .red)
                        : .gray
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .stroke(isSelected && isOpened ? .black : .clear, lineWidth: 4)
                    )
            }
        )
    }
}

#Preview {
    ContentView()
}
