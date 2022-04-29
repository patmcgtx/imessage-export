//
//  AppDelegate.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/28/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func saveAction(_ sender: AnyObject?) {
        
        // For now, this is just a place to trigger some code
                
        if let dbURL = ChatDbSelector().promtForChatDb() {            
            let chat = ChatDb(fileURL: dbURL)
            let num = chat.numMessages
            print(num)
        }

    }
    
}

