//
//  ReportResponseDTO.swift
//  Memory
//
//  Created by 황채웅 on 8/13/25.
//

import Foundation

typealias ReportResponseDTO = ResponseDTO<ReportResponseDTOData>

struct ReportResponseDTOData: Codable {
    let userId: Int
    let date: String
    let total: Total
    let detail: [Detail]
    let advice: String
    
    struct Total: Codable {
        let score: Double
        let danger: String
        let weak: [String]
        let summary: [String]
    }
    
    struct Detail: Codable, Hashable {
        let type: String
        let score: Int
        let scoreDifference: Int
        let location: Int
        let danger: Int
        let danger_level: String
    }
}
