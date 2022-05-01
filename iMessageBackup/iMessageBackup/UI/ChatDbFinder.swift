//
//  ChatDbFinder.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import AppKit
import UniformTypeIdentifiers

/// Provides a way to find the chat database file.
struct ChatDbFinder {
    
    /**
     Opens a dialog for the user to find and pick the chat database.
     
     Due to app sandboxing, we have to prompt the user to manually pick the `chat.db` file;
     we can't just go grab it.  I guess this makes sense security-wise. 🤷🏻‍♂️
     
     - Returns: A URL with the location of the selected database file, or `nil` if none.
     */
    func promptForChatDb() -> URL? {
        
        let openPanel = NSOpenPanel();
        
        openPanel.title = "Locate chat.db";
        openPanel.showsResizeIndicator = true;
        openPanel.showsHiddenFiles = true;
        openPanel.allowsMultipleSelection = false;
        openPanel.canChooseDirectories = false;
        openPanel.resolvesAliases = true
        openPanel.isExtensionHidden = false
        openPanel.canCreateDirectories = false
        openPanel.allowedContentTypes = [UTType(filenameExtension: ".db"),
                                         UTType(filenameExtension: ".sqlite"),
                                         UTType(filenameExtension: ".sqlite3e")].compactMap{$0}
        openPanel.allowsOtherFileTypes = false
        
        if (openPanel.runModal() ==  NSApplication.ModalResponse.OK) {
            return openPanel.url
        } else {
            return nil
        }
    }
    
}
