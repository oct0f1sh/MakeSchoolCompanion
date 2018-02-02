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
    
    var allStudents: [Student] = []
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        self.textField.text = ""
        self.errorLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        textField.delegate = self
        
        loginButton.showLoader(userInteraction: false)
        
        NetworkingService.getAllStudents { (students) in
            if let students = students {
                self.allStudents = students
                DispatchQueue.main.async {
                    self.loginButton.hideLoader()
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if !(textField.text?.contains("."))! {
            errorLabel.isHidden = false
            errorLabel.text = "format must be firstname.lastname"
            return
        }
        
        let nameString = textField.text?.components(separatedBy: ".")
        let firstname = nameString![0].lowercased()
        let lastname = nameString![1].lowercased()
        
        for student in allStudents {
            if student.firstname.lowercased() == firstname && student.lastname.lowercased() == lastname {
                let idView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! IDViewController
                idView.student = student
                DispatchQueue.main.async {
                    self.present(idView, animated: true, completion: nil)
                }
                return
            }
        }
        
        errorLabel.text = "user not found"
        errorLabel.isHidden = false
    }
    
    @objc func tap(gesture: UIGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
