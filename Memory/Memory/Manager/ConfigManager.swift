//
//  ConfigManager.swift
//  Memory
//
//  Created by 황채웅 on 8/7/25.
//

import Foundation

final class ConfigManager {
    static var elevenLabsApiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "ELEVENLABS_API_KEY") as? String
    }
}
