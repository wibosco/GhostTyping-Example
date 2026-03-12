//
//  ChainingAnimationsViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 30/10/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class ChainingAnimationsViewController: UIViewController {
    @IBOutlet weak var firstTypingLabel: UILabel!
    @IBOutlet weak var secondTypingLabel: UILabel!
    @IBOutlet weak var thirdTypingLabel: UILabel!
    
    var animationTimer: Timer?
    
    // MARK: - ViewLifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationTimer?.invalidate()
    }
    
    // MARK: - ButtonActions
    
    @IBAction func animatorButtonPressed(_ sender: Any) {
        startTypingAnimation()
    }
    
    // MARK: - Animation
    
    private func startTypingAnimation() {
        animationTimer?.invalidate()
        
        makeInvisible(label: firstTypingLabel)
        makeInvisible(label: secondTypingLabel)
        makeInvisible(label: thirdTypingLabel)
        
        animateTyping(label: firstTypingLabel,
                      completion: { [weak self] in
            self?.animateTyping(label: self?.secondTypingLabel,
                                completion: {
                self?.animateTyping(label: self?.thirdTypingLabel,
                                    completion: nil)
            })
        })
    }
    
    private func animateTyping(label: UILabel?,
                               completion: (() -> Void)?) {
        var characterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true) { timer in
            if let label = label, let attributedText = label.attributedText {
                let characters = Array(attributedText.string)
                
                if characterIndex < characters.count {
                    let attributedString = NSMutableAttributedString(attributedString: attributedText)
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                                  value: label.textColor.withAlphaComponent(1),
                                                  range: NSMakeRange(characterIndex, 1))
                    label.attributedText = attributedString
                    
                    characterIndex += 1
                } else {
                    timer.invalidate()
                    
                    completion?()
                }
            } else {
                timer.invalidate()
                
                completion?()
            }
        }
    }
    
    private func makeInvisible(label: UILabel) {
        guard let attributedText = label.attributedText else {
            return
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: label.textColor.withAlphaComponent(0),
                                      range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedString
    }
}
