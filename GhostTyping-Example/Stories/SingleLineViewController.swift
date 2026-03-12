//
//  SingleLineViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 30/10/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class SingleLineViewController: UIViewController {
    @IBOutlet weak var typingLabel: UILabel!
    
    var animationTimer: Timer?
    var fullTextToBeWritten: String?
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullTextToBeWritten = typingLabel.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationTimer?.invalidate()
    }
    
    // MARK: - ButtonActions
    
    @IBAction func animatorButtonPressed(_ sender: Any) {
        animateTyping()
    }
    
    // MARK: - Animation
    
    private func animateTyping() {
        animationTimer?.invalidate()
        typingLabel.text = nil
        
        var characterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true) { [weak self] (timer: Timer) in
            if let fullTextToBeWritten = self?.fullTextToBeWritten, let label = self?.typingLabel {
                let characters = Array(fullTextToBeWritten)
                
                if characterIndex < characters.count {
                    let nextCharacterToAdd = String(characters[characterIndex])
                    
                    if let currentText = label.text {
                        label.text = currentText + nextCharacterToAdd
                    } else {
                        label.text = nextCharacterToAdd
                    }
                    
                    characterIndex += 1
                } else {
                    timer.invalidate()
                }
            } else {
                timer.invalidate()
            }
        }
    }
}
