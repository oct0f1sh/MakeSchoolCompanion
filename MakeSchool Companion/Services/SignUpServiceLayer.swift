//
//  SignUpServiceLayer.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/13/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

var keychain = KeychainSwift()
class SignUpServicingLayer {
    func verifyUserSlug(slugName: String, completionHandler: @escaping(Data, Int) -> Void) {
        var getRequest = URLRequest(url:URL(string: "https://www.makeschool.com/portfolios/\(keychain.get("portfolio")).json")!)
        
        let session = URLSession.shared
        session.dataTask(with: getRequest) { (data, response, error) in
            let statusCode: Int = (response as! HTTPURLResponse).statusCode
            completionHandler(data, statusCode)
        }
    }
}
