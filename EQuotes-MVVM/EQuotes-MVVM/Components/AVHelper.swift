//
//  Helpers.swift
//  EQuotes-MVVM
//
//  Created by Thuyên Trương on 22/04/2023.
//

import AVFoundation

struct AVHelper {

    static let shared = AVHelper()
    private init() {}

    let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        // this  AVAudioSession method is for speak text when device is in silent mode
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback,mode: .default)

        } catch let error {
            logger.error("This error message from SpeechSynthesizer \(error.localizedDescription)")
        }
        #endif

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.35

        synthesizer.speak(utterance)
    }
}
