//
//  ChatReader.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import Foundation
import SQLite

/// Reads a chat database and supplies information about it.
struct ChatReader {
    
    private var db: Connection?
    private let chatTable = ChatSchema.ChatTable()
    private let messageTable = ChatSchema.MessageTable()

    /**
     Creates a chat database reader for the given database path.
     - Parameter dbPath: A path to the chat database.
     - Returns: A chat reader instance _or_ `nil` if the database can't be read.
     */
    init?(dbPath: String) {
        do {
            self.db = try Connection(dbPath, readonly: true)
        } catch {
            return nil
        }
    }
    
    /// Creates a chat reader for the given database connection
    init(db: Connection) {
        self.db = db
    }
    
    /// Counts metrics from the chat database.
    var metrics: Swift.Result<ChatMetrics, Error> {
        do {
            let numChats = try self.db?.scalar(self.chatTable.sqliteTable.select(self.chatTable.idColumn.count)) ?? -1
            let numMessages = try self.db?.scalar(self.messageTable.sqliteTable.select(self.messageTable.idColumn.count)) ?? -1
            return .success(ChatMetrics(numChats: numChats, numMessages: numMessages))
        } catch {
            return .failure(error)
        }
    }

}
