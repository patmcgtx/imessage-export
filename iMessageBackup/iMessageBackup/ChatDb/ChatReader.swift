//
//  ChatDb.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import Foundation
import SQLite

/// Reads a chat database and supplies information about it.
struct ChatReader {
    
    private var db: Connection?
    
    /**
     Creates a chat database reader for the given database path.
     - Parameter dbPath: A path to the chat database.
     - Returns: A chat reader instance _or_ `nil` if the database can't be read.
     */
    init?(dbPath: String) {
        do {
            self.db = try Connection(dbPath, readonly: true)
        } catch {
            print(error) // TODO patmcg add error handling
            return nil
        }
    }
    
    /// Counts metrics from the chat database.
    var metrics: Swift.Result<ChatMetrics, Error> {
        do {
            let chats = Table("chat")
            let guid = Expression<String>("guid")
            let numChats = try db?.scalar(chats.select(guid.count)) ?? -1
            
            let messages = Table("message")
            let numMessages = try db?.scalar(messages.select(guid.count)) ?? -1

            return .success(ChatMetrics(numChats: numChats, numMessages: numMessages))
        } catch {
            return .failure(error)
        }
    }

}
