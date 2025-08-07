//
//  AppleSTTManager.swift
//  Memory
//
//  Created by 황채웅 on 8/7/25.
//

import Foundation
import Speech

final class AppleSTT {
    
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var recognitionTask: SFSpeechRecognitionTask?

    func recognizeSpeech(from url: URL) async throws -> String {
        let request = SFSpeechURLRecognitionRequest(url: url)
        return try await withCheckedThrowingContinuation { continuation in
            recognizer?.recognitionTask(with: request) { result, error in
                if let result = result {
                    continuation.resume(returning: result.bestTranscription.formattedString)
                } else if let error = error {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
