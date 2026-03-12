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
        guard let fullTextToBeWritten = self.fullTextToBeWritten else {
            return
        }
        
        animationTimer?.invalidate()
        typingLabel.text = nil
        
        let characters = Array(fullTextToBeWritten)
        var characterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true) { [weak self] (timer: Timer) in
            guard let label = self?.typingLabel, characterIndex < characters.count else {
                timer.invalidate()
                
                return
            }
            
            let nextCharacterToAdd = String(characters[characterIndex])
            
            label.text = (label.text ?? "") + nextCharacterToAdd
            
            characterIndex += 1
        }
    }
}
