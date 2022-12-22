//
//  ViewController.swift
//  KeyboardTests
//
//  Created by Miles Vinson on 12/21/22.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    private let doneButton = UIButton(type: .system)
    
    private let textView = UITextView()
    
    private var textViewDidBeginEditingTime: CFTimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.text = DummyText.loremIpsum
        self.textView.textColor = UIColor.label
        self.textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        self.textView.textContainerInset = UIEdgeInsets(top: 32, left: 24, bottom: 32, right: 24)
        self.textView.delaysContentTouches = false
        self.textView.delegate = self
        self.view.addSubview(self.textView)
        
        self.doneButton.setTitle("Done", for: .normal)
        self.doneButton.contentHorizontalAlignment = .right
        self.doneButton.addAction(UIAction(handler: { _ in
            self.textView.resignFirstResponder()
        }), for: .primaryActionTriggered)
        self.view.addSubview(self.doneButton)
        
        // keyboardWillChangeFrameNotification and keyboardWillShowNotification have nearly the same delay
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .current, using: { _ in
            
            guard let editingTime = self.textViewDidBeginEditingTime else { return }
            
            let elapsed = CACurrentMediaTime() - editingTime
            let milliseconds: Int = Int(elapsed * 1000)
            
            // Xcode 13.4.1:  30-50ms
            // Xcode 14:      100-300s
            print("Elapsed: \(milliseconds)ms")
            
            self.textViewDidBeginEditingTime = nil
        })
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        // Set textViewDidBeginEditingTime to the current time so we can check how much time has passed
        // until the keyboard notification fires.
        self.textViewDidBeginEditingTime = CACurrentMediaTime()
        
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.doneButton.frame = CGRect(
            x: self.view.bounds.maxX - 24 - 80,
            y: self.view.safeAreaInsets.top,
            width: 80,
            height: 60
        )
        
        self.textView.frame = self.view.bounds
            .inset(by: UIEdgeInsets(top: self.doneButton.frame.maxY, left: 0, bottom: 0, right: 0))
    }


}

struct DummyText {
    
    static let loremIpsum: String =
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
    
}
