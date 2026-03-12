//
//  IterativelyChainingAnimationsViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 30/10/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class IterativelyChainingAnimationsViewController: UIViewController {
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
        
        configureLabel(label: firstTypingLabel,
                       alpha: 0,
                       until: firstTypingLabel.text?.count)
        
        configureLabel(label: secondTypingLabel,
                       alpha: 0,
                       until: secondTypingLabel.text?.count)
        
        configureLabel(label: thirdTypingLabel,
                       alpha: 0,
                       until: thirdTypingLabel.text?.count)
        
        animateText(label: firstTypingLabel,
                    completion: { [weak self] in
            self?.animateText(label: self?.secondTypingLabel,
                              completion: {
                self?.animateText(label: self?.thirdTypingLabel,
                                  completion: nil)
            })
        })
    }
    
    private func animateText(label: UILabel?,
                     completion: (() -> Void)?) {
        var showCharactersUntilIndex = 1
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1,
                                              repeats: true,
                                              block: { [weak self] (timer: Timer) in
            if let label = label, let attributedText = label.attributedText {
                let characters = Array(attributedText.string)
                
                if showCharactersUntilIndex <= characters.count {
                    self?.configureLabel(label: label,
                                         alpha: 1,
                                         until: showCharactersUntilIndex)
                    
                    showCharactersUntilIndex += 1
                } else {
                    timer.invalidate()
                    
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
    
    private func configureLabel(label: UILabel,
                        alpha: CGFloat,
                        until: Int?) {
        if let attributedText = label.attributedText  {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                          value: label.textColor.withAlphaComponent(CGFloat(alpha)),
                                          range: NSMakeRange(0, until ?? 0))
            label.attributedText = attributedString
        }
    }
}
