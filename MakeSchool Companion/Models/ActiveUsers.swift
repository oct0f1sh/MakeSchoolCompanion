//
//  ActiveUsers.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class ActiveUser: NSObject, NSCoding, Codable {
    var email: String!
    var password: String!
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    required init?(coder aDecoder: NSCoder) {
        guard let email = aDecoder.decodeObject(forKey: "email") as? String,
            let password = aDecoder.decodeObject(forKey: "password") as? String
            else{return nil}
        self.email = email
        self.password = password
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
    }
}


