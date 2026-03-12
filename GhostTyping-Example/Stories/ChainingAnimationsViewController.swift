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
        startTextAnimation()
    }
    
    // MARK: - Animation
    
    private func startTextAnimation() {
        animationTimer?.invalidate()
        
        makeInvisible(label: firstTypingLabel)
        makeInvisible(label: secondTypingLabel)
        makeInvisible(label: thirdTypingLabel)
        
        animateText(label: firstTypingLabel,
                    completion: { [weak self] in
            self?.animateText(label: self?.secondTypingLabel,
                              completion: {
                self?.animateText(label: self?.thirdTypingLabel,
                                  completion: nil)
            })
        })
    }
    
    // 5
    private func animateText(label: UILabel?,
                             completion: (() -> Void)?) {
        var characterIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true,
                                              block: { timer in
            if let label = label, let attributedText = label.attributedText {
                let characters = Array(attributedText.string)
                
                if characterIndex < characters.count {
                    let attributedString = NSMutableAttributedString(attributedString: attributedText)
                    attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                                  value: label.textColor.withAlphaComponent(CGFloat(1)),
                                                  range: NSMakeRange(characterIndex, 1))
                    label.attributedText = attributedString
                    
                    characterIndex += 1
                } else {
                    timer.invalidate()
                    
                    // 6
                    if let completion = completion {
                        completion()
                    }
                }
            } else {
                timer.invalidate()
                
                if let completion = completion {
                    completion()
                }
            }
        })
    }
    
    private func makeInvisible(label: UILabel) {
        guard let attributedText = label.attributedText else {
            return
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedText)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: label.textColor.withAlphaComponent(CGFloat(0)),
                                      range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedString
    }
}
