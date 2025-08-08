//
//  TTSManager.swift
//  Memory
//
//  Created by 황채웅 on 8/7/25.
//

import AVFoundation
import Combine

final class TTSManager {
    private var audioPlayer: AVAudioPlayer
    
    static let shared = TTSManager()
    
    init() {
        self.audioPlayer = AVAudioPlayer()
    }
    
    enum Voice {
        case ChungMan
        case HanAim
        case MinJoon
        
        var voiceId: String {
            switch self {
            case .ChungMan: "8MwPLtBplylvbrksiBOC"
                // Middle-aged female meditative, blissful voice.
            case .HanAim: "8jHHF8rMqMlg8if2mOUe"
                //Natural, casual, podcast-style voice with a free-flowing, spontaneous, and unscripted feel, perfect for everyday conversation.
            case .MinJoon: "nbrxrAz3eYm9NgojrmFK"
                // Young adult, Male, Perfect for professional korean narration, youtube storytelling, intelligent speech, audio book, gaming, class, education & motivation
            }
        }
    }

    func textToSpeech(text: String, voice: Voice) async throws {
        guard let apiKey = ConfigManager.elevenLabsApiKey else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API Key is missing"])
        }

        guard let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/\(voice.voiceId)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

        let body: [String: Any] = [
            "text": text,
            "model_id": "eleven_multilingual_v2",
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.5
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)
        dump(response)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // 오디오 재생
        audioPlayer = try AVAudioPlayer(data: data)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}
