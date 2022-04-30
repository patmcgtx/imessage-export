//
//  ChatDb.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import Foundation
import SQLite

/// Reads a chata database and returns information about it.
struct ChatReader {
    
    private var db: Connection?
    
    /**
     Creates a chat database reader for the give databse path.
     - Parameter dbPath: A path to the chat database to read.
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
    
    /**
     The total number of messages in the chat database
     */
    var numMessages: Swift.Result<Int, Error> {
        do {
            let messages = Table("message")
            let text = Expression<String>("text")
            let count = try db?.scalar(messages.select(text.count)) ?? -1
            return .success(count)
        } catch {
            print(error) // TODO patmcg add error handling
            return .failure(error)
        }
    }
    
}
