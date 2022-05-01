//
//  ChatSchema.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import SQLite

/// TODO patmcg
protocol SQLiteTable {
    var table: Table { get }
}

/// TODO patmcg
struct ChatSchema {
        
    struct ChatTable: SQLiteTable {
        var table: Table { Table("chat") }
        let idColumn = Expression<Int>("ROWID")
        let guidColumn = Expression<String>("guid")
    }

    struct MessageTable: SQLiteTable {
        var table: Table { Table("message") }
        let idColumn = Expression<Int>("ROWID")
        let guidColumn = Expression<String>("guid")
        let textColumn = Expression<String>("text")
    }
    
}
