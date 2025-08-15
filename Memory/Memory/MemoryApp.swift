//
//  MemoryApp.swift
//  Memory
//
//  Created by 황채웅 on 8/7/25.
//

import SwiftUI
import Moya

@main
struct MemoryApp: App {
    
    @State var navigationPath: NavigationPath = .init()
    @State private var selectedTab = 0
    
    let name = "멋쟁이 정진태 대표"
    let userId = 3423
    
    init() {
        Fonts.registerCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                HomeView(navigationPath: $navigationPath, onTabSelection: {
                    selectedTab = 1
                }, name: name)
                    .tabItem {
                        Label("홈", systemImage: "house")
                    }
                    .tag(0)
                
                NavigationStack(path: $navigationPath) {
                    SelectGameView(navigationPath: $navigationPath)
                        .navigationDestination(for: String.self) { value in
                            viewBuilder(path: value)
                                .navigationBarBackButtonHidden()
                                .toolbar(.hidden, for: .tabBar)
                        }
                }
                .tabItem {
                    Label {
                        Text("퀴즈")
                    } icon: {
                        Image(.iconTabQuiz)
                            .renderingMode(.template)
                    }
                }
                .tag(1)
                ReportView(name: name, userId: userId)
                    .tabItem {
                        Label("리포트", systemImage: "book")
                    }
                    .tag(2)
            }
            .preferredColorScheme(.light)
            .tint(.mainGreen)
        }
    }
    
    @ViewBuilder
    func viewBuilder(path: String) -> some View {
        switch path {
        case "loadingCardGame":
            GameLoadingView(
                mainColor: .gameOrange,
                categoryTitle: "기억력",
                title: "카드를 보고\n그림을 기억해\n뒤집힌 카드를\n짝지어 주세요",
                timerSeconds: 8,
                destinationViewString: "cardGame",
                navigationPath: $navigationPath
            )
        case "loadingColorGame":
            GameLoadingView(
                mainColor: .gameGreen,
                categoryTitle: "주의력/반응속도",
                title: "글자의 내용이\n아닌,\n글자의 색깔을\n맞혀주세요",
                timerSeconds: 8,
                destinationViewString: "colorGame",
                navigationPath: $navigationPath
            )
        case "loadingSentenceGame":
            GameLoadingView(
                mainColor: .gameBlue,
                categoryTitle: "논리력/언어",
                title: "섞인 낱말을\n올바른 순서로\n배열하세요",
                timerSeconds: 8,
                destinationViewString: "sentenceGame",
                navigationPath: $navigationPath
            )
        case "colorGame":
            TextColorQuizView(
                viewModel: TextColorQuizViewModel(
                    useCase: GenerateTextColorQuizUseCase(), navigationPath: $navigationPath, userId: userId
                )
            )
        case "cardGame":
            MemoryGameView(viewModel: MemoryGameViewModel(navigationPath: $navigationPath, userId: userId))
        case "sentenceGame":
            WordGameView(viewModel: WordGameViewModel(navigationPath: $navigationPath, userId: userId))
        default:
            ZStack {
                Text("잘못된 접근입니다.")
            }
        }
    }
}

