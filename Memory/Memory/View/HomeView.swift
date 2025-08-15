//
//  HomeView.swift
//  Memory
//
//  Created by 황채웅 on 8/12/25.
//

import SwiftUI
import MarkdownUI

struct HomeView: View {
    
    @Binding var navigationPath: NavigationPath
    let onTabSelection: () -> Void
    let name: String
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                TitleView(name: name)
                    .padding(.top, 32)
                    .padding(.bottom, 32)
                Button(
                    action: {
                        onTabSelection()
                    }, label: {
                        Text("퀴즈 시작하기")
                            .font(.big44)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .background(.mainGreen)
                            .cornerRadius(20)
                            .shadow(color: Color(white: 0.85), radius: 20, x: 4, y: 4)
                            .padding(.bottom, 40)
                    }
                )
                Button(
                    action: {
                        
                    }, label: {
                        HStack(spacing: 15) {
                            Image(.iconStatistics)
                                .resizable()
                                .frame(width: 38, height: 44)
                            VStack {
                                Text("전주 대비 기억력 추이가 좋아요!")
                                    .font(.subtitle1)
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("주간 리포트 확인하기")
                                    .font(.subtitle6)
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 24)
                        .frame(height: 115)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(24)
                        .shadow(color: Color(white: 0.85), radius: 24, x: 4, y: 4)
                        .padding(.bottom, 24)
                    }
                )
                Button(
                    action: {
                        
                    }, label: {
                        HStack(spacing: 15) {
                            Image(.iconPieChart)
                                .resizable()
                                .frame(width: 38, height: 38)
                            VStack {
                                Text("또래 평균보다 논리력이 높아요")
                                    .font(.subtitle1)
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("연령군 평균 대비 분석 확인하기")
                                    .font(.subtitle6)
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 24)
                        .frame(height: 115)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(24)
                        .shadow(color: Color(white: 0.85), radius: 24, x: 4, y: 4)
                    }
                )
            }
            .padding(.horizontal, 24)
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.95))
    }
}

enum GameDestination: String {
    case card
    case color
    case sentence
    
    var title: String {
        switch self {
        case .card:
            "카드를 보고\n그림을 기억해\n뒤집힌 카드를\n짝지어 주세요"
        case .color:
            "글자의 내용이\n아닌,\n글자의 색깔을\n맞혀주세요"
        case .sentence:
            "섞인 낱말을\n올바른 순서로\n배열하세요"
        }
    }
    
    var category: String {
        switch self {
        case .card:
            "기억력"
        case .color:
            "주의력/반응속도"
        case .sentence:
            "논리력/언어"
        }
    }
    
    var mainColor: Color {
        switch self {
        case .card:
                .gameOrange
        case .color:
                .gameGreen
        case .sentence:
                .gameBlue
        }
    }
}

private struct TitleView: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text("\(name)님, 안녕하세요!")
                .font(.big44)
                .foregroundStyle(.black)
                .padding(.bottom, 24)
            Text("오늘도 집중하러 가볼까요?")
                .font(.big36)
                .foregroundStyle(.black)
        }
    }
}
