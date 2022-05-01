//
//  ChatSchema.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 5/1/22.
//

import Foundation

struct ChatSchema {
    
    enum table {
        case chat
        case message
    }
    
    enum column {
        case id
        case guid
        case text
    }
    
}
