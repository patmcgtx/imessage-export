//
//  Chat.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import Foundation

/// Represents a chat conversation
struct Chat {
    
    let id: Int
    let chatIdentifier: String
    let recipient: Person?
    
    var debugDescription: String {
        let recipientName = recipient?.debugDescription ?? "unknown"
        return "Chat #\(self.id) \(self.chatIdentifier) with \(recipientName)"
    }
}
