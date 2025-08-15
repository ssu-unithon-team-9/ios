//
//  NetworkManager.swift
//  Memory
//
//  Created by 황채웅 on 8/12/25.
//

import Foundation
import Moya
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private let provider: MoyaProvider<MemoryTarget>
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10000
        configuration.timeoutIntervalForResource = 10000
        
        provider = MoyaProvider<MemoryTarget>(
            session: Alamofire.Session(configuration: configuration),
            plugins: [NetworkLoggerPlugin()]
        )
    }
    
    // MARK: - GET Request
    func get<T: Decodable>(_ target: MemoryTarget, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - POST Request
    func post<T: Decodable>(_ target: MemoryTarget, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - PUT Request
    func put<T: Decodable>(_ target: MemoryTarget, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - DELETE Request
    func delete<T: Decodable>(_ target: MemoryTarget, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
