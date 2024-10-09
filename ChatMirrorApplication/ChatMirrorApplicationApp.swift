//
//  ChatMirrorApplicationApp.swift
//  ChatMirrorApplication
//
//  Created by Kishan on 09/10/24.
//

import SwiftUI
import SwiftData

@main
struct ChatMirrorApplicationApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Message.self, inMemory: false)
        }
        
    }
}
