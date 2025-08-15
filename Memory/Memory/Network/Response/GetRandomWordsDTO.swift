//
//  GetRandomWordsDTO.swift
//  Memory
//
//  Created by 황채웅 on 8/12/25.
//

import Foundation

public typealias GetRandomWordsDTO = ResponseDTO<GetRandomWordsDTOData>

public struct GetRandomWordsDTOData: Decodable {
    let words: [String]
    let lang: String
    let length: Int
    let pos: String
}
