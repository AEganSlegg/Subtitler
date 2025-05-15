//
//  SubtitlerApp.swift
//  Subtitler
//
//  Created by Amber on 17/11/2024.
//

import SwiftUI
import Speech

@main
struct SubtitlerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .frame(minWidth: 400, minHeight: 300)
            .id("mainWindow")
            .padding()
            .onOpenURL { url in
                print("Open URL: \(url)")
                #if os(iOS)
                UIApplication.shared.open(url)
#endif
            }
        }
    }
}
