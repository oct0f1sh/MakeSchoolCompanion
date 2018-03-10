//
//  MSUserObjectModel.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 3/7/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct MSUserModelObject {
    var id: Int
    var email: String
    var token: String
    var createdAt: String
    var updatedAt: String
    var imageUrl: String
    var firstName: String
    var lastName:String
    init(id: Int, email: String, token: String, createdAt: String, updatedAt: String, imageUrl: String, firstName: String, lastName: String) {
        self.id = id
        self.email = email
        self.token = token
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.imageUrl = imageUrl
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension MSUserModelObject: Decodable {
    enum FirstLevelKeys: String, CodingKey {
        case id
        case email
        case token
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case imageUrl = "image_url"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirstLevelKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let email = try container.decode(String.self, forKey: .email)
        let token = try container.decode(String.self, forKey: .token)
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        let updatedAt = try container.decode(String.self, forKey: .updatedAt)
        let imageUrl = try container.decode(String.self, forKey: .imageUrl)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        self.init(id: id, email: email, token: token, createdAt: createdAt, updatedAt: updatedAt, imageUrl: imageUrl, firstName: firstName, lastName: lastName)
    }
}
