//
//  ContentView.swift
//  Subtitler2
//
//  Created by Amber on 21/01/2025.
//


// Imports frameworks
import SwiftUI
import Speech

// Defines variables
struct ContentView: View {
    @State private var presentImporter: Bool = false
    @State private var path = URL(string: "")
    @State private var transcript: String = ""
    @State private var document: MessageDocument = MessageDocument(message: "")
    @State private var isRecording: Bool = false
    @State private var isPlaying: Bool = false
    @State private var presentExporter: Bool = false
    @State private var exportURL: URL?
    @State private var audioURL: URL?
    @State private var showingAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
// UI starts here
    var body: some View {
// Vertical stack
        VStack {
            #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
//Checks if operating system version matches what's needed
            if #available(iOS 14.0, macOS 11.0, *) {
//Text that introduces user to app function. Microphone symbol was suppoed to reprompt consent, but that didn't function
                Text("Subtitler")
                    .font(.largeTitle)
                    .padding()
                Text(Image(systemName:"microphone.circle.fill"))
                    .font(.title)
                    .foregroundColor(.orange)
                    .padding()
                Text("A simple tool to aid in creating subtitles from audio files. Upload a file (mp3, wav, aiff) and click the buttons below to generate and download a transcript, ready for you to edit!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineLimit(450)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Text("(Note: This app only works on macOS 11 and iPadOS/iOS 14 and later.)")
                    .padding()
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
#endif
//File importer
            Button("Choose audio file") {
                presentImporter = true
            }
            .padding(10)
            .buttonStyle(.bordered)
            .tint(.orange)
//Checks that files are of the right type
                .fileImporter(isPresented: $presentImporter, allowedContentTypes: [.mp3, .wav, .aiff])
            { result in
                switch result {
                case .success(let url):
                    print(url)
                    path = url
                    url.startAccessingSecurityScopedResource()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
//Subtitle generator, calls transcribe function
            Button("Generate subtitles") { transcribe()
            }
            .padding(10)
            .buttonStyle(.borderedProminent)
            .tint(.orange)
//Saves file, creates document with transcript.
            Button("Save to file") {
                if transcript != "" {
                    document = MessageDocument(message: "\(transcript)")
                    self.presentExporter = true
                }
            }
            .padding(10)
            .buttonStyle(.bordered)
            .tint(.orange)
//Shows alert
                .alert("The transcript has been successfully saved to your downloads folder!", isPresented: $showingAlert){
                    Button("OK (Press to dismiss)") {}
                    }
//Exports file
                .fileExporter(isPresented: $presentExporter, document: document, contentType: .plainText, defaultFilename: "Subtitles.srt")
            { result in
                if case.success = result {
                    self.showingAlert = true
                }
            }
//Explains to user what to do with generated file.
            Text("File will be saved as a .srt file in your downloads folder. Timstamps should be added manually in the format HH:MM:SS,SSS, where SSS is milliseconds. For example, 00:00:01,234 --> 00:00:02,123. Before each line, a number should be added, starting with 1.")
                .font(.body)
                .multilineTextAlignment(.center)
                .lineLimit(450)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        }
    }
//Transcribe function
    func transcribe() {
//Requests authorisation on first run.
        SFSpeechRecognizer.requestAuthorization {
            authstatus in
            DispatchQueue.main.async {
                if authstatus == .authorized {
                    print("Authorised")
//Calls function to transcribe file
                    transcribeFile(url: path!)
                } else {
                    print("Not authorised")
                }
            }
        }
    }
//Function to transcribe file
    func transcribeFile(url: URL) {
//Checks that speech is in British English
        guard let recogniser = SFSpeechRecognizer(locale: Locale(identifier: "en_GB")) else {
            print("Could not create recogniser for current locale")
            return
        }
//Displays if recogniser is busy
        if !recogniser.isAvailable {
            print("Recogniser not available")
            return
        }
        let path_to_audio_file = url
        print(path_to_audio_file)
//Transcribes audio
        let request = SFSpeechURLRecognitionRequest(url: path_to_audio_file)
        recogniser.recognitionTask(with: request){
            (result, error) in
            guard let result = result else {
//Displays if the file cannot be transcribed
                print("Failed to get result \(error!) \n Please try again")
                return
            }
            if result.isFinal {
                print(result.bestTranscription.formattedString)
                transcript = result.bestTranscription.formattedString
            }
        }
    }
}
//File creator
struct MessageDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    var message: String
    init(message: String) {
        self.message = message
    }
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
}
#Preview {
    ContentView()
}
