//
//  ViewController.swift
//  Subtitler
//
//  Created by Amber on 01/02/2025.
//

import UIKit
import Speech

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch SFSpeechRecognizer.authorizationStatus() {
                case.authorized:
                    let audioURL = Bundle.main.url(forResource: "test", withExtension: "m4a")!
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: audioURL)
                    recognizer?.recognitionTask(with: request) { result, error in
                        guard let result = result else {
                            print("Failed to recognise speech: \(error!) - please ensure microphone access is enabled in settings")
                            return
                        }
                        self.textView.text = result.bestTranscription.formattedString
                    }
                    break
                default:
                    break
                }
            }
        }
    }
}
