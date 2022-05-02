//
//  InMemoryChatDb.swift
//  iMessageBackupTests
//
//  Created by Patrick McGonigle on 5/1/22.
//

import SQLite
@testable import iMessageBackup

/// A read/write in-memory chat database for testing
struct InMemoryChatDb {
    
    private(set) var connection: Connection? = nil
    private let chatTable = ChatSchema.ChatTable()
    private let messageTable = ChatSchema.MessageTable()

    /// Creates an empty in-memory chat database
    init() throws {
        
        // In-memory database
        self.connection = try Connection()
        
        try self.connection?.run(chatTable.table.create { table in
            table.column(chatTable.idColumn, primaryKey: true)
            table.column(chatTable.chatIdentifierColumn)
        })
        
        try self.connection?.run(messageTable.table.create { table in
            table.column(messageTable.idColumn, primaryKey: true)
            table.column(messageTable.textColumn)
        })
    }
    
    // MARK: - Single insert functions
    
    /// Inserts a chat row into this database
    func insert(chat: Chat) throws {
        try self.connection?.run(self.chatTable.table.insert(
            self.chatTable.idColumn <- chat.id,
            self.chatTable.chatIdentifierColumn <- chat.chatIdentifier))
    }

    /// Inserts a message row into this database
    func insert(message: Message) throws {
        try self.connection?.run(self.messageTable.table.insert(
            self.messageTable.idColumn <- message.id,
            self.messageTable.textColumn <- message.text))
    }

    // MARK: - Bulk insert functions
        
    func insertChats(count: Int) throws {
        let chats = Array(1...count).map { Chat(id: $0, chatIdentifier: "person\($0)@example.com", recipient: nil) }
        for chat in chats {
            try self.insert(chat: chat)
        }
    }

    func insertMessages(count: Int) throws {
        let messages = Array(1...count).map { Message(id: $0, text: "Message \($0)") }
        for message in messages {
            try self.insert(message: message)
        }
    }

}
