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
    
    var allStudents: [Student] = []
    
    var student: Student? = nil
    
    var user: User? = nil
    
    
    var keyboardIsPresent = false
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        self.emailField.text = ""
        self.passwordField.text = ""
    }
    
    @IBAction func emailDidBeginEditing(_ sender: Any) {
        
        
        animateUp()
        keyboardIsPresent = true
    }
    
    @IBAction func passwordDidBeginEditing(_ sender: Any) {
        
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
    
    @IBAction func loginButton(_ sender: Any) {
        EmailandPasswordandToken.email = emailField.text!
        EmailandPasswordandToken.password = passwordField.text!
        let beaconLogic = BeaconNetworkingLayer()
        
        let nameString = emailField.text?.components(separatedBy: ".")
      
        let firstname = nameString![0].lowercased()
        
        var tempLastName = nameString![1].lowercased()
        var formattingLastName = tempLastName.components(separatedBy: "@")
        var lastName = formattingLastName[0].lowercased()
        
        
        for student in allStudents {
            if student.firstname.lowercased() == firstname && student.lastname.lowercased() == lastName {
                self.student = student
                beaconLogic.fetchBeaconData(route: .users, completionHandler: { (data, response) in
                    if response >= 200 && response < 300 {
                        let json = try? JSONDecoder().decode(User.self, from: data)
                        print("This is the user \(json)")
                        let idView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! IDViewController
                        EmailandPasswordandToken.token = (json?.token)!
                        idView.student = self.student
                        DispatchQueue.main.async {
                            self.present(idView, animated: true, completion: nil)
                        }
                    }
                }, requestRoute: .getRequest)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        NetworkingService.getAllStudents { (students) in
            if let students = students {
                self.allStudents = students
            }
        }
    }
    
    @objc func tap(gesture: UIGestureRecognizer) {
        animateDown()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        keyboardIsPresent = false
    }
}
