//
//  TestLoginViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 2/9/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class TestLoginViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var gradient: UIImageView!
    @IBOutlet weak var fullStackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientBottomConstraint: NSLayoutConstraint!

    let defaults = UserDefaults.standard

    var logoTranslation: CGFloat = 125
    var stackViewBottomConstraintOffset: CGFloat = 65

    var allStudents: [Student] = []

    var student: Student? = nil

    var user: User? = nil


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


        animateUp()
        keyboardIsPresent = true
    }

    @IBAction func passwordDidBeginEditing(_ sender: Any) {

        animateUp()
        keyboardIsPresent = true
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
                        self.defaults.set(true, forKey: "LoggedIn")
                        if self.defaults.bool(forKey: "LoggedIn") == true {
                            print("User has succesfully logged in")
                        }

                        let idView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! IDViewController
                        EmailandPasswordandToken.token = (json?.token)!

                        let keychain = KeychainSwift()
                        keychain.set(EmailandPasswordandToken.token, forKey: "Token")
                        keychain.set((self.student?.imageURL)!, forKey: "ImageURL")
                        keychain.set((self.student?.firstname)!, forKey: "firstName")
                        keychain.set((self.student?.lastname)!, forKey: "lastName")
                        keychain.set((self.student?.email)!, forKey: "email")
                        keychain.set((self.student?.portfolio)!, forKey: "portfolio")

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
    }
}
