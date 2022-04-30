//
//  ChatDbSelector.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/29/22.
//

import Foundation
import AppKit

// TODO patmcg doc
struct ChatDbSelector {
    
    // TODO patmcg doc
    // add security reasons why we need to prompt the user
    func promtForChatDb() -> URL? {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a file| Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = true;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        dialog.resolvesAliases = true
        //        dialog.allowedFileTypes = ...
        //        dialog.allowedContentTypes = ...
        dialog.isExtensionHidden = false
        dialog.canCreateDirectories = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the selected file
            return result
        } else {
            return nil
        }
    }
    
}
