//
//  ChatDb.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import Foundation
import SQLite

// TODO patmcg doc
struct ChatDb {
    
    private var db: Connection?
    
    // TODO patmcg doc
    init(fileURL: URL) {
        // TODO patmcg handle if db read fails
        // TODO patmcg generate correct path to ~/Library
        do {
            self.db = try Connection(fileURL.path, readonly: true)
        } catch {
            // authorization denied (code: 23)
            print(error)
        }
    }
    
    // TODO patmcg doc
    var numMessages: Int {
        do {
            let messages = Table("messag")
            let count = try self.db?.scalar(messages.count)
            return count ?? -1
        } catch {
            print(error)
            return -1
        }
    }
    
}
