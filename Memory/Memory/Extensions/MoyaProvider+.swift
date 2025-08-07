//
//  MoyaProvider+.swift
//  Memory
//
//  Created by 황채웅 on 8/7/25.
//

import Moya
import Combine

extension MoyaProvider {
    
    func requestPublisher(
        _ target: Target
    ) -> AnyPublisher<Response, MoyaError> {
        self.requestPublisher(target)
            .flatMap { response -> AnyPublisher<Response, MoyaError> in
                switch response.statusCode {
                case 200..<300:
                    return Just(response)
                        .setFailureType(to: MoyaError.self)
                        .eraseToAnyPublisher()
                default:
                    let error = MoyaError.statusCode(response)
                    dump(error)
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
