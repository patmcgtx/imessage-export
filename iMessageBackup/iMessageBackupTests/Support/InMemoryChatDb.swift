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
    
    // TODO patmcg move these to a common area to be reused with the main app
    private let chatsTable = Table("chat")
    private let messagesTable = Table("message")
    private let idColumn = Expression<Int>("ROWID")
    private let guidColumn = Expression<String>("guid")
    private let textColumn = Expression<String>("text")

    /// Creates an empty in-memory version of a chat database
    init() throws {
        
        // In-memory database
        self.connection = try Connection()
        
        try self.connection?.run(self.chatsTable.create { table in
            table.column(self.idColumn, primaryKey: true)
            table.column(self.guidColumn, unique: true)
        })
        
        try self.connection?.run(self.messagesTable.create { table in
            table.column(self.idColumn, primaryKey: true)
            table.column(self.guidColumn, unique: true)
            table.column(self.textColumn)
        })
    }
    
    // MARK: - Update functions
    
    /// Inserts a chat row into this database
    func insert(chat: Chat) throws {
        try self.connection?.run(self.chatsTable.insert(self.idColumn <- chat.id, self.guidColumn <- chat.guid))
    }

    /// Inserts a message row into this database
    func insert(message: Message) throws {
        try self.connection?.run(self.messagesTable.insert(
            self.idColumn <- message.id,
            self.guidColumn <- message.guid,
            self.textColumn <- message.text))
    }

}
