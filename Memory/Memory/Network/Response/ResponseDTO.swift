//
//  ResponseDTO.swift
//  Memory
//
//  Created by 황채웅 on 8/12/25.
//

import Foundation

public struct ResponseDTO<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T
}
