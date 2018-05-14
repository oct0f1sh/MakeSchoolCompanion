//
//  User.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/10/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    var id: Int!
    var email: String!
    var createdAt: String!
    var token: String!
    init(id:Int, email: String, createdAt: String, token:String) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.token = token
    }
}

extension User {
    enum TopLevelKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelKeys.self)
        let id = try? container.decodeIfPresent(Int.self, forKey: .id)
        let email = try? container.decodeIfPresent(String.self, forKey: .email)
        let createdAt = try? container.decodeIfPresent(String.self, forKey: .createdAt)
        let token = try? container.decodeIfPresent(String.self, forKey: .token)
        self.init(id: id as! Int, email: email as! String, createdAt: createdAt as! String, token: token as! String)
    }
}


