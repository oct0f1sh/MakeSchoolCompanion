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
    var stackTranslation: CGFloat = 280
    
    var keyboardIsPresent = false
    
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
    
    func animateUp() {
        if !keyboardIsPresent {
            UIView.animate(withDuration: 0.25) {
                self.logoImage.frame.origin.y -= self.logoTranslation
                self.logoTopConstraint.constant -= self.logoTranslation
                
                self.fullStackView.frame.origin.y -= self.stackTranslation
                self.stackBottomConstraint.constant += self.stackTranslation
                
                self.gradient.frame.origin.y -= self.stackTranslation
                self.gradientBottomConstraint.constant += self.stackTranslation
            }
        }
    }
    
    func animateDown() {
        if keyboardIsPresent {
            UIView.animate(withDuration: 0.1) {
                self.logoImage.frame.origin.y += self.logoTranslation
                self.logoTopConstraint.constant += self.logoTranslation
                
                self.fullStackView.frame.origin.y += self.stackTranslation
                self.stackBottomConstraint.constant -= self.stackTranslation
                
                self.gradient.frame.origin.y += self.stackTranslation
                self.gradientBottomConstraint.constant -= self.stackTranslation
            }
        }
    }
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tap(gesture: UIGestureRecognizer) {
        animateDown()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        keyboardIsPresent = false
    }
}
