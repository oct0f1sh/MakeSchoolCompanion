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
    var id: String
    var email: String
    var token: String
    var createdAt: String
    var updatedAt: String
    var imageUrl: String
    var firstName: String
    var lastName:String
    init(id: String, email: String, token: String, createdAt: String, updatedAt: String, imageUrl: String, firstName: String, lastName: String) {
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
        case id = "user_id"
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
        let id = try container.decodeIfPresent(String.self, forKey: .id) ?? "No Id given"
        let email = try container.decodeIfPresent(String.self, forKey: .email) ?? "No email given"
        let token = try container.decodeIfPresent(String.self, forKey: .token) ?? "No Token given"
        let createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? "No created at given"
        let updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? "No updated at given"
        let imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? "No image url given"
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? "No first name given"
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? "No last name given"
        self.init(id: id, email: email, token: token, createdAt: createdAt, updatedAt: updatedAt, imageUrl: imageUrl, firstName: firstName, lastName: lastName)
    }
}
