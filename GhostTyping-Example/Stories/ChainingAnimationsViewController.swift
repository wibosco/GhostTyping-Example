//
//  ChainingAnimationsViewController.swift
//  GhostTyping-Example
//
//  Created by William Boles on 30/10/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import UIKit

class ChainingAnimationsViewController: UIViewController {

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
        animateText()
    }
    
    // MARK: Animation
    
    func animateText() {
        animationTimer?.invalidate()
        configureLabel(label: firstTypingLabel, alpha: 0, until: firstTypingLabel.text?.characters.count)
        configureLabel(label: secondTypingLabel, alpha: 0, until: secondTypingLabel.text?.characters.count)
        configureLabel(label: thirdTypingLabel, alpha: 0, until: thirdTypingLabel.text?.characters.count)
        
        animateCharacters(label: firstTypingLabel, completion: { [weak self] in
            self?.animateCharacters(label: self?.secondTypingLabel, completion: {
                self?.animateCharacters(label: self?.thirdTypingLabel, completion: nil)
            })
        })
    }
    
    func animateCharacters(label: UILabel?, completion: (()->Void)?) {
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
