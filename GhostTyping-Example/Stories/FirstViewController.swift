//
//  FirstViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 30/10/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var typingLabel: UILabel!
    @IBOutlet weak var animatorButton: UIButton!
    
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
        animateText()
    }
    
    // MARK: Animation
    
    func animateText() {
        animationTimer?.invalidate()
        typingLabel.text = nil
        
        var nextCharacterIndexToBeShown = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer: Timer) in
            if let fullTextToBeWritten = self?.fullTextToBeWritten {
                let characters = Array(fullTextToBeWritten.characters)
                
                if nextCharacterIndexToBeShown < characters.count {
                    if let label = self?.typingLabel {
                        let nextCharacterToAdd = String(characters[nextCharacterIndexToBeShown])
                        
                        if let currentText = label.text {
                            label.text = currentText + nextCharacterToAdd
                        } else {
                            label.text = nextCharacterToAdd
                        }
                    }
                    
                    nextCharacterIndexToBeShown += 1
                } else {
                    timer.invalidate()
                }
            } else {
                timer.invalidate()
            }
        })
    }
}

