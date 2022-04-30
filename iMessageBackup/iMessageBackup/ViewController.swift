//
//  ViewController.swift
//  iMessageBackup
//
//  Created by Patrick McGonigle on 4/28/22.
//

import Cocoa

class ViewController: NSViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func findChatDb(_ sender: Any) {
        if let dbURL = ChatDbFinder().promptForChatDb() {
            let chatReader = ChatReader(dbPath: dbURL.path)
            switch chatReader?.metrics {
            case .success(let metrics):
                self.updateFindDbStatus("Found \(metrics.numMessages) messages and \(metrics.numChats) chats.", didSucceed: true)
            case .failure(let error):
                self.updateFindDbStatus(error.localizedDescription, didSucceed: false)
            case .none:
                self.updateFindDbStatus("Can't read database.", didSucceed: false)
            }
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var findDbStatusLabel: NSTextField!
    @IBOutlet weak var findDbThumbsUp: NSImageView!
    
    private func updateFindDbStatus(_ status: String, didSucceed: Bool) {
        self.findDbStatusLabel.stringValue = status
        self.findDbThumbsUp.isHidden = !didSucceed
    }

    // MARK: - Data flow
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

