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
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

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
    var user_id: String?
    var profileImageUrl: String?
    
    var roster_identification_numbers = [Int]()


    var keyboardIsPresent = false

    var keyboardHeight: CGFloat! {
        didSet {
            print(keyboardHeight)
        }
    }

    @IBAction func unwindToLoginFromIdViewController(segue: UIStoryboardSegue) {
        self.emailField.text = ""
        self.passwordField.text = ""
        let loggedInValue = self.defaults.bool(forKey: "LoggedIn")
        if loggedInValue == true {
            self.defaults.set(false, forKey: "LoggedIn")
        }
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
        
        guard let emailText = emailField.text,
            let passwordText = passwordField.text else {return}
       
        
        beaconLogic.fetchBeaconData(route: .users(email: emailText, password: passwordText), completionHandler: { (user, response) in
            guard let studentIdentificationNumber = keychain.get("id") else {return}
            if response >= 200 && response < 300 {
                let idView = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! IDViewController
                for id in self.roster_identification_numbers {
                    if id == Int(studentIdentificationNumber) {
                        self.defaults.set(true, forKey: "LoggedIn")
                        DispatchQueue.main.async {
                            self.present(idView, animated: true, completion: nil)
                        }
                    }
                }
                
            }
        }, requestRoute: .postReuqest)
    }
    
    @IBAction func facebookLoginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "ToWebView", sender: nil)
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
        
        
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor.darkGray
        myLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 140)
        myLoginButton.center = view.center
        myLoginButton.setTitle("Facebook SDK Login", for: .normal)
        
        // Handle clicks on the button
        myLoginButton.addTarget(self, action: #selector(self.facebookLogin), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
        
    }
    
    @objc func facebookLogin() {
        // This is the function for the default facebook login using their sdk
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userHometown], viewController: self) { (loginResult) in
            switch loginResult {
            case .success( _,  _,  _):
                guard let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email"]) else {return}
                graphRequest.start(completionHandler: { (connection, result, error) in
                    guard let resultDictionary = result as? NSDictionary else {return}
                    print(resultDictionary.value(forKey: "name") ?? "No Name Available")
                })
                UserDefaults.standard.set(true, forKey: "FacebookLogin")
            case .cancelled:
                print("User canceled the login")
            case .failed(let error as NSError?):
                print("There was an error logging in: \(error?.localizedDescription ?? "Error is present")")
            }
        }
        
    }

    @objc func tap(gesture: UIGestureRecognizer) {
        animateDown()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    

}
