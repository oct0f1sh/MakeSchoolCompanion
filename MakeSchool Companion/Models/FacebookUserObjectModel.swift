//
//  FacebookUserObjectModel.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 5/2/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct FacebookUser {
    var firstName: String
    var lastName: String
    var email: String
    var role: String
    var profileImageUrl: String
    init(firstName: String, lastName: String, email: String, role: String, profileImageUrl: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.role = role
        self.profileImageUrl = profileImageUrl
    }
}

extension FacebookUser: Decodable {
    enum FirstLevelKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case role
        case profileImageUrl = "profile_image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirstLevelKeys.self)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let email = try container.decode(String.self, forKey: .email)
        let role = try container.decode(String.self, forKey: .role)
        let profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        self.init(firstName: firstName, lastName: lastName, email: email, role: role, profileImageUrl: profileImageUrl)
    }
}
