//
//  ViewController.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/28/22.
//

import Cocoa

// TODO patmcg eventually redo this in SwiftUI (TEXTBAK-34)

class ViewController: NSViewController {
        
    // MARK: - Outlets
    
    @IBOutlet weak var findDbStatusLabel: NSTextField!
    @IBOutlet weak var findDbThumbsUp: NSImageView!
    @IBOutlet weak var exportOptionsButton: NSButton!
    @IBOutlet weak var exportOptionsThumbsUp: NSImageView!
    @IBOutlet weak var exportOptionsStatusLabel: NSTextField!
    
    // MARK: - Actions
    
    @IBAction func findChatDb(_ sender: Any) {
        if let dbURL = ChatDbFinder().promptForChatDb() {
            self.chatReader = ChatReader(dbPath: dbURL.path, reversePhoneBook: AppleContacts())
            // TODO patmcg localize strings (TEXTBAK-42)
            switch self.chatReader?.metrics {
            case .success(let metrics):
                self.updateFindDbStatus("Found \(metrics.numMessages) messages and \(metrics.numChats) chats.", didSucceed: true)
            case .failure(let error):
                self.updateFindDbStatus(error.localizedDescription, didSucceed: false)
            case .none:
                self.updateFindDbStatus("Can't read database.", didSucceed: false)
            }
        }
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private

    private var chatReader: ChatReader? = nil

    private func updateFindDbStatus(_ status: String, didSucceed: Bool) {
        
        self.findDbStatusLabel.stringValue = status
        self.findDbStatusLabel.isHidden = false
        self.findDbThumbsUp.isHidden = !didSucceed
        
        if didSucceed {
            // TODO patmcg move this
            
            let allKnownChats = self.chatReader?.allChatsWithKnownContacts
            var statusMessage = ""
            
            // TODO patmcg localize strings (TEXTBAK-42)
            switch allKnownChats {
            case .success(let chats):
                statusMessage = "Exporting \(chats.count) chats with known contacts using .csv."
                self.exportOptionsStatusLabel.stringValue = statusMessage
            case .failure(let error):
                statusMessage = error.localizedDescription
            case .none:
                statusMessage = "No chats found."
            }
            
            self.exportOptionsStatusLabel.stringValue = statusMessage
            self.exportOptionsStatusLabel.isHidden = false
            self.exportOptionsThumbsUp.isHidden = false
        }
    }
    
    // MARK: - Data flow
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}

