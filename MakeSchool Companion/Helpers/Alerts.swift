//
//  HelperFunctions.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/9/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit


func loginAlert(controller: UIViewController) {
    let alert = UIAlertController(title: "Log In Error", message: "Please Try Logging In Again At A Later Time", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(cancelAction)
    controller.present(alert, animated: true, completion: nil)
}

func signUpAlert(controller: UIViewController) {
    let alert = UIAlertController(title: " Sign Up Error", message: "Please Try Signing Up At A Later Time", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(cancelAction)
    controller.present(alert, animated: true, completion: nil)
}
