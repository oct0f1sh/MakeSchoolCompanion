//
//  HelperFunctions.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/9/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

struct StaticProperties {
    static var email = ""
    static var firstName = ""
    static var lastName = ""
    static var role = ""
    static var imageUrl = ""
}

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

func showFacebookUserProfile(controller: UIViewController, completionHandler: @escaping(Int) -> Void) {
    let url = URL(string: "https://www.makeschool.com/login.json")
    let keychain = KeychainSwift()
    let session = URLSession.shared
    //                let cookieHeaderField = ["Set-Cookie":"_makeschool_session=\(keychain.get("cookieValue")!)"]
    //                let cookies = HTTPCookie.cookies(withResponseHeaderFields: cookieHeaderField, for: url!)
    //                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: url)

    var getRequest = URLRequest(url: url!)
    getRequest.setValue("_makeschool_session=\(keychain.get("cookieValue")!)", forHTTPHeaderField: "Cookie")
    getRequest.httpMethod = "POST"
    getRequest.httpShouldHandleCookies = true

    session.dataTask(with: getRequest, completionHandler: { (data, response, error) in
        let statusCode: Int = (response as! HTTPURLResponse).statusCode
        print(data?.base64EncodedString(), response)
        guard let decodedUser = try? JSONDecoder().decode(FacebookUser.self, from: data!) else {return}
        //        keychain.set(decodedUser.email, forKey: "email")
        //        keychain.set(decodedUser.firstName, forKey: "firstName")
        //        keychain.set(decodedUser.lastName, forKey: "lastName")
        //        keychain.set(decodedUser.role, forKey: "role")
        //        keychain.set(decodedUser.profileImageUrl, forKey: "profileImageUrl")
        StaticProperties.email = decodedUser.email
        StaticProperties.firstName = decodedUser.firstName
        StaticProperties.lastName = decodedUser.lastName
        StaticProperties.imageUrl = decodedUser.profileImageUrl
        StaticProperties.role = decodedUser.role
        completionHandler(statusCode)

        print("This is the decoded user \(decodedUser)")
    }).resume()
}



func searchUsers(controller: UIViewController) {
    let beaconNetworkingLayer = BeaconNetworkingLayer()
    
    beaconNetworkingLayer.fetchBeaconData(route: .facebookCallback(email: StaticProperties.email, firstName: StaticProperties.firstName, lastName: StaticProperties.lastName, imageUrl: StaticProperties.imageUrl), completionHandler: { (user, response) in
        print("This is the response of the callback we made from facebook \(response)")
        
        let idView = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! IDViewController
        UserDefaults.standard.set(true, forKey: "LoggedIn")
        DispatchQueue.main.async {
            controller.present(idView, animated: true, completion: nil)
        }
    }, requestRoute: .postReuqest)
    
}

