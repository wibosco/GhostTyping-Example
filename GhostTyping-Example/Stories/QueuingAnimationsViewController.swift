//
//  QueuingAnimationsViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 04/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class QueuingAnimationsViewController: UIViewController {
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
        
        let typingAnimationLabelQueue = [firstTypingLabel, secondTypingLabel, thirdTypingLabel].compactMap { $0 }
        
        for typingAnimationLabel in typingAnimationLabelQueue {
            makeInvisible(label: typingAnimationLabel)
        }
        
        var labelIndex = 0
        
        func doAnimation() {
            guard labelIndex < typingAnimationLabelQueue.count else {
                return
            }
            
            let typingAnimationLabel = typingAnimationLabelQueue[labelIndex]
            labelIndex += 1
            
            animateTyping(label: typingAnimationLabel) {
                doAnimation()
            }
        }
        
        doAnimation()
    }
    
    private func animateTyping(label: UILabel?,
                               completion: (() -> Void)?) {
        guard let label = label, let attributedText = label.attributedText else {
            completion?()
            
            return
        }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        
        let characters = Array(attributedText.string)
        var characterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true) { timer in
            guard characterIndex < characters.count else {
                timer.invalidate()
                completion?()
                
                return
            }
            
            mutableAttributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                                 value: label.textColor.withAlphaComponent(1),
                                                 range: NSMakeRange(characterIndex, 1))
            label.attributedText = mutableAttributedString
            
            characterIndex += 1
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
