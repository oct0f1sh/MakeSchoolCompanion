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
    var user_id: Int?
    var profileImageUrl: String?
    
    var roster_identification_numbers = [Int]()


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

        let tempLastName = nameString![1].lowercased()
        var formattingLastName = tempLastName.components(separatedBy: "@")
        let lastName = formattingLastName[0].lowercased()
        
        
        guard let emailText = emailField.text,
            let passwordText = passwordField.text else {return}
        let student = ActiveUser(email: emailText, password: passwordText)
        beaconLogic.fetchBeaconData(route: .users, student: student, completionHandler: { (data, response) in
            if response >= 200 && response < 300 {
                guard let json = try? JSONDecoder().decode(MSUserModelObject.self, from: data) else{return}
                self.user_id = json.id
                self.profileImageUrl = json.profileImageUrl
                let keychain = KeychainSwift()
                keychain.set(self.profileImageUrl!, forKey: "profileImageUrl")
                keychain.set(json.email, forKey: "email")
                keychain.set(json.firstName, forKey: "firstName")
                keychain.set(json.lastName, forKey: "lastName")
                keychain.set(json)
                let idView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! IDViewController
                for id in self.roster_identification_numbers {
                    if id == self.user_id {
                        DispatchQueue.main.async {
                            self.present(idView, animated:true, completion: nil)
                        }
                    }
                }

            }
        }, requestRoute: .postReuqest)
    }
    
  
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)

        NetworkingService.getAllStudents { (students) in
            if let students = students {
                self.allStudents = students
            }
        }
        fetchStudentIdentification(target: .myStudents, success: { (response) in
           guard let studentIds = try? response.mapJSON() else {return}
            print("These are the student identification numbers \(studentIds)")
            for id in (studentIds as? [Int])! {
                self.roster_identification_numbers.append(id)
            }
        }, error: { (error) in
            print(error.localizedDescription)
        }) { (moyaError) in
            print(moyaError)
        }
    }

    @objc func tap(gesture: UIGestureRecognizer) {
        animateDown()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
