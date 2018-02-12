//
//  ActiveUsers.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct ActiveUser: Codable {
    var email: String!
    var password: String!
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}


