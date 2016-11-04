//
//  RecursivelyChainingAnimationsViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 04/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class RecursivelyChainingAnimationsViewController: UIViewController {

    // MARK: - Properties
    
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
    
    func startTextAnimation() {
        animationTimer?.invalidate()
        
        var typingAnimationLabelQueue = [firstTypingLabel, secondTypingLabel, thirdTypingLabel]
        
        for typingAnimationLabel in typingAnimationLabelQueue {
            configureLabel(label: typingAnimationLabel!, alpha: 0, until: typingAnimationLabel!.text?.characters.count)
        }
        
        func doAnimation() {
            guard typingAnimationLabelQueue.count > 0 else {
                return
            }
            
            let typingAnimationLabel = typingAnimationLabelQueue.removeFirst()
            
            animateTyping(label: typingAnimationLabel) {
                doAnimation()
            }
        }
        
        doAnimation()
    }
    
    func animateTyping(label: UILabel?, completion: (()->Void)?) {
        var showCharactersUntilIndex = 1
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer: Timer) in
            if let label = label, let attributedText = label.attributedText {
                let characters = Array(attributedText.string.characters)
                
                if showCharactersUntilIndex <= characters.count {
                    self?.configureLabel(label: label, alpha: 1, until: showCharactersUntilIndex)
                    
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
    
    func configureLabel(label: UILabel, alpha: CGFloat, until: Int?) {
        if let attributedText = label.attributedText  {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: label.textColor.withAlphaComponent(CGFloat(alpha)), range: NSMakeRange(0, until ?? 0))
            label.attributedText = attributedString
        }
    }
}
