//
//  SignUserUp.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/10/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct SignUserUp: Codable {
    var email: String!
    var password: String!
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
