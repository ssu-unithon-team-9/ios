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
    let timerSeconds: Double
    let destinationViewString: String
    @State private var progress: CGFloat = 0.0
    @Binding var navigationPath: NavigationPath
        
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .cornerRadius(12)
                        .padding(.bottom, 24)
                    Rectangle()
                        .foregroundStyle(mainColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 24)
                        .cornerRadius(12)
                        .padding(.trailing, geo.size.width*(1-progress))
                        .padding(.bottom, 24)
                }
                Spacer(minLength: 0)
                VStack(alignment: .leading) {
                    Text(categoryTitle)
                        .font(.headline4)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(mainColor)
                        .cornerRadius(22)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(title)
                        .font(.headline1)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 300)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    let timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
                        if progress < 1.0 {
                            progress += 0.001 / CGFloat(timerSeconds)
                        } else {
                            progress = 1.0
                            self.navigationPath.removeLast(1)
                            self.navigationPath.append(destinationViewString)
                        }
                    }
                    // Invalidate timer after timerSeconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(timerSeconds)) {
                        timer.invalidate()
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 28)
        }
    }
}
