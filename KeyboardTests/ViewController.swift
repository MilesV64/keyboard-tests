//
//  ViewController.swift
//  KeyboardTests
//
//  Created by Miles Vinson on 12/21/22.
//

import UIKit

class DummyKeyInput: UIView, UIKeyInput {
    
    var hasText: Bool {
        return false
    }
    
    func insertText(_ text: String) {
        
    }
    
    func deleteBackward() {
        
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
}

class ViewController: UIViewController, UITextViewDelegate {
    
    private var becomeFirstResponderTime: CFTimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dummpyInputView = DummyKeyInput()
        self.view.addSubview(dummpyInputView)
        
        // cycles between becoming/resigning first responder
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if dummpyInputView.isFirstResponder {
                dummpyInputView.resignFirstResponder()
            }
            else {
                self.becomeFirstResponderTime = CACurrentMediaTime()
                dummpyInputView.becomeFirstResponder()
            }
        })
        
        // keyboardWillChangeFrameNotification and keyboardWillShowNotification have nearly the same delay
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .current, using: { _ in
            
            guard let editingTime = self.becomeFirstResponderTime else { return }
            
            let elapsed = CACurrentMediaTime() - editingTime
            let milliseconds: Int = Int(elapsed * 1000)
            
            // Xcode 13.4.1:  30-50ms
            // Xcode 14:      100-300s
            print("Elapsed: \(milliseconds)ms")
            
            self.becomeFirstResponderTime = nil
        })
    }
    
}
