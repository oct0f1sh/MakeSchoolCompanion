//
//  LoginViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 2/2/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import PMSuperButton

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginButton: PMSuperButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var animLogo: UIImageView!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var makeLogo: UIImageView!
    
    var token: String?
    
    var allStudents: [Student] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.animate()
        
        textField.delegate = self
        
        loginButton.showLoader(userInteraction: false)
        
        NetworkingService.getAllStudents { (students) in
                self.allStudents = students
                print("These are the students \(students)")
                DispatchQueue.main.async {
                    self.loginButton.hideLoader()
                }
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func animate() {
        self.textField.alpha = 0
        self.textField.isUserInteractionEnabled = false
        self.loginButton.alpha = 0
        self.loginButton.isUserInteractionEnabled = false
        self.underlineView.alpha = 0
        self.domainLabel.alpha = 0
        self.atLabel.alpha = 0
        self.makeLogo.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay: 1, options: [], animations: {
            self.animLogo.frame.origin.x = 36
            self.animLogo.frame.origin.y = 181
            self.animLogo.bounds = CGRect(x: 67, y: 207, width: 88, height: 99)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 1.8, options: [], animations: {
            self.textField.alpha = 1
            self.loginButton.alpha = 1
            self.underlineView.alpha = 1
            self.domainLabel.alpha = 1
            self.atLabel.alpha = 1
            self.makeLogo.alpha = 1
        }, completion: { (_) in
            self.textField.isUserInteractionEnabled = true
            self.loginButton.isUserInteractionEnabled = true
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if !(textField.text?.contains("."))! && textField.text != "" {
            errorLabel.isHidden = false
            errorLabel.text = "format must be firstname.lastname"
            underlineView.backgroundColor = Style.Colors.makeRed
            return
        } else if textField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "please enter required fields"
            underlineView.backgroundColor = Style.Colors.makeRed
            return
        }
        
        let nameString = textField.text?.components(separatedBy: ".")
        let firstname = nameString![0].lowercased()
        let lastname = nameString![1].lowercased()
        
//        for student in allStudents {
//            if student.firstname.lowercased() == firstname && student.lastname.lowercased() == lastname {
//                let idView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! IDViewController
//                idView.student = student
//                DispatchQueue.main.async {
//                    self.present(idView, animated: true, completion: nil)
//                }
//                return
//            }
//        }
        
        
//        errorLabel.text = "user not found"
//        errorLabel.isHidden = false
    }
    
    @objc func tap(gesture: UIGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
