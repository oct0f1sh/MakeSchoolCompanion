//
//  TestLoginViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 2/9/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class TestLoginViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var gradient: UIImageView!
    @IBOutlet weak var fullStackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientBottomConstraint: NSLayoutConstraint!
    
    var logoTranslation: CGFloat = 125
    var stackViewBottomConstraintOffset: CGFloat = 65
    
    var keyboardIsPresent = false
    
    var keyboardHeight: CGFloat! {
        didSet {
            print(keyboardHeight)
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        self.emailField.text = ""
        self.passwordField.text = ""
    }
    
    @IBAction func emailDidBeginEditing(_ sender: Any) {
        print("email")

        animateUp()
        keyboardIsPresent = true
    }
    
    @IBAction func passwordDidBeginEditing(_ sender: Any) {
        print("password")
        
        animateUp()
        keyboardIsPresent = true
    }
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        observeKeyboard()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.keyboardHeight == nil || !(self.keyboardHeight > 0) {
                self.keyboardHeight = keyboardFrame.height
            }
        }
    }
    
    // Shows the keyboard to get the height. Height cannot be gathered unless the keyboard is shown
    func observeKeyboard() {
        let field = UITextField()
        self.view.addSubview(field)
        field.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            field.resignFirstResponder()
            field.removeFromSuperview()
        }
    }
    
    func animateUp() {
        print("animate up")
        if !keyboardIsPresent {
            UIView.animate(withDuration: 0.35) {
                self.logoImage.frame.origin.y -= self.logoTranslation
                self.logoTopConstraint.constant -= self.logoTranslation
                
                self.fullStackView.frame.origin.y -= self.keyboardHeight
                self.stackBottomConstraint.constant += self.keyboardHeight - self.stackViewBottomConstraintOffset
                
                self.gradient.frame.origin.y -= self.keyboardHeight
                self.gradientBottomConstraint.constant += self.keyboardHeight
            }
            keyboardIsPresent = true
        }
    }
    
    func animateDown() {
        print("animate down")
        if keyboardIsPresent {
            UIView.animate(withDuration: 0.1) {
                self.logoImage.frame.origin.y += self.logoTranslation
                self.logoTopConstraint.constant += self.logoTranslation
                
                self.fullStackView.frame.origin.y += self.keyboardHeight
                self.stackBottomConstraint.constant -= self.keyboardHeight - self.stackViewBottomConstraintOffset
                
                self.gradient.frame.origin.y += self.keyboardHeight
                self.gradientBottomConstraint.constant -= self.keyboardHeight
            }
            keyboardIsPresent = false
        }
    }
    
    @objc func tap(gesture: UIGestureRecognizer) {
        animateDown()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
