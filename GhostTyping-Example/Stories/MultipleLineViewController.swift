//
//  MultipleLineViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 30/10/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class MultipleLineViewController: UIViewController {
    @IBOutlet weak var typingLabel: UILabel!
    
    var animationTimer: Timer?
    
    // MARK: - ViewLifecycle
    
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
        guard let attributedText = typingLabel.attributedText else {
            return
        }
        
        animationTimer?.invalidate()
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        
        mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                             value: typingLabel.textColor.withAlphaComponent(0),
                                             range: NSMakeRange(0, attributedText.length))
        typingLabel.attributedText = mutableAttributedString
        
        let characters = Array(attributedText.string)
        var characterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true) { [weak self] (timer: Timer) in
            guard let label = self?.typingLabel, characterIndex < characters.count else {
                timer.invalidate()
                
                return
            }
                
            mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                                 value: label.textColor.withAlphaComponent(1),
                                                 range: NSMakeRange(characterIndex, 1))
            label.attributedText = mutableAttributedString
            
            characterIndex += 1
        }
    }
}
