//
//  Message.swift
//  ChatMirrorApplication
//
//  Created by Kishan on 09/10/24.
//

import Foundation
import SwiftData

@Model
class Message {
    @Attribute(.unique) var id: UUID
    var content: String
    var isSentByUser: Bool
    var timestamp: Double
    
    init(content: String, isSentByUser: Bool) {
        self.id = UUID()
        self.content = content
        self.isSentByUser = isSentByUser
        self.timestamp = Date().timeIntervalSince1970
    }
}
