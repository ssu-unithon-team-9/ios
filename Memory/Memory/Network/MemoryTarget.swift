//
//  MemoryTarget.swift
//  Memory
//
//  Created by 황채웅 on 8/12/25.
//

import Moya
import Foundation

enum MemoryTarget: TargetType {
    case profile // 테스트용
    case randomWords(length: Int)
    case saveGame(userId: Int, type: String, count: Int, totalCount: Int)
    case getReport(userId: Int)
    
    var baseURL: URL {
        if let url = URL(string: "http://13.209.50.239") {
            return url
        } else {
            fatalError()
        }
    }
    
    var path: String {
        switch self {
        case .profile:
            "/profile"
        case .randomWords:
            "/api/words/random"
        case .saveGame:
            "/api/v1/report/score"
        case .getReport(userId: let userId):
            "/api/v1/report"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile:
            .get
        case .randomWords:
            .get
        case .saveGame:
            .post
        case .getReport(userId: let userId):
            .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .profile:
            return .requestPlain
        case let .randomWords(length):
            return .requestParameters(parameters: ["length": length], encoding: URLEncoding.queryString)
        case let .saveGame(userId, type, count, totalCount):
            let dto = SaveScoreRequestDTO(userId: userId, type: type, count: count, totalCount: totalCount)
            return .requestJSONEncodable(dto)
        case .getReport(userId: let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .profile:
            ["Content-Type": "application/json"]
        case .randomWords:
            ["Content-Type": "application/json"]
        case .saveGame:
            ["Content-Type": "application/json"]
        case .getReport(userId: let userId):
            ["Content-Type": "application/json"]
        }
    }
}
