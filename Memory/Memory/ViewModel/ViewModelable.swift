//
//  ViewModelable.swift
//  Memory
//
//  Created by 황채웅 on 8/8/25.
//

import Foundation

protocol ViewModelable: ObservableObject {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    
    func action(_ action: Action)
}
