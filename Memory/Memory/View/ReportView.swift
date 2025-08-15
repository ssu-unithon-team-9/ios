//
//  ReportView.swift
//  Memory
//
//  Created by 황채웅 on 8/13/25.
//

import SwiftUI

struct ReportView: View {
    let userId: Int
    let name: String
    
    @State private var data: ReportResponseDTO? = nil
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    
    init(name: String, userId: Int) {
        self.name = name
        self.userId = userId
        Fonts.registerCustomFonts()
    }
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("데이터를 불러오는 중...")
            } else if let data = data {
                VStack(spacing: 24) {
                    Text("\(name)님,\n전보다 발전하고 있어요!")
                        .font(.big40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Rectangle()
                        .foregroundStyle(Color.black.opacity(0.05))
                        .frame(maxWidth: .infinity)
                        .frame(height: 2)
                    
                    ForEach(data.data.total.summary, id: \.self) { item in
                        Text("\(item)")
                            .font(.big32)
                            .lineSpacing(50)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack(spacing: 20) {
                        VStack(spacing: 10) {
                            Text("종합점수")
                                .font(.headline3)
                                .foregroundStyle(.gray)
                                .lineSpacing(40)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "%.2f점", data.data.total.score))
                                .font(.headline2)
                                .foregroundStyle(.mainGreen)
                                .lineSpacing(40)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        VStack(spacing: 10) {
                            Text("위험도 점수")
                                .font(.headline3)
                                .foregroundStyle(.gray)
                                .lineSpacing(40)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(data.data.total.danger)
                                .font(.headline2)
                                .foregroundStyle(.mainGreen)
                                .lineSpacing(40)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    Text("✨ AI 생활 조언")
                        .font(.big36)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(data.data.advice)
                        .font(.big32)
                        .foregroundStyle(.black)
                        .lineSpacing(40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 12) {
                        Text("취약유형")
                            .font(.big32)
                            .foregroundStyle(.black)
                        ForEach(data.data.total.weak, id:\.self) { text in
                            Text(text)
                                .font(.big32)
                                .foregroundStyle(.white)
                                .padding(24)
                                .background(.mainGreen)
                                .cornerRadius(12)
                        }
                    }
                    DetailView(detail: data.data.detail)
                        .frame(maxWidth: .infinity)
                    
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                .cornerRadius(30)
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.05))
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        isLoading = true
        NetworkManager.shared.get(.getReport(userId: userId)) { (result: Result<ReportResponseDTO, any Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedData):
                    self.data = fetchedData
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    print("Error fetching report: \(error)")
                }
            }
        }
    }
}

struct DetailView: View {
    let detail: [ReportResponseDTOData.Detail]
    var body: some View {
        HStack {
            ForEach(detail, id:\.self) { detail in
                VStack {
                    Text(detail.type)
                        .font(.body1)
                        .foregroundStyle(.black)
                    Text("\(detail.score)점")
                        .font(.body1)
                        .foregroundStyle(.black)
                    Text("\(detail.scoreDifference)")
                        .font(.body1)
                        .foregroundStyle(.black)
                    Text("\(detail.danger_level)")
                        .font(.body1)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
