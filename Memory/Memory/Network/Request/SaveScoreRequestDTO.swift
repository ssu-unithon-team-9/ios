//
//  SaveScoreRequestDTO.swift
//  Memory
//
//  Created by 황채웅 on 8/13/25.
//

import Foundation

struct SaveScoreRequestDTO: Codable {
    let userId: Int
    let type: String
    let count: Int
    let totalCount: Int
}
