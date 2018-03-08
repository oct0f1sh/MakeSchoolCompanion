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
    var email:String
    var createdAt: String
    var updatedAt: String
    var firstName: String
    var lastName: String
    var academy: Bool
    var role: String
    var profileImageUrl: String
    var personalReferralCode: String
    
    init(id: Int, email: String, createdAt: String, updatedAt: String, firstName: String, lastName: String, academy:Bool, role: String, profileImageUrl: String, personalReferralCode: String) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.firstName = firstName
        self.lastName = lastName
        self.academy = academy
        self.role = role
        self.profileImageUrl = profileImageUrl
        self.personalReferralCode = personalReferralCode
    }
}

extension MSUserModelObject: Decodable {
    enum FirstLevelKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case academy
        case role
        case profileImageUrl = "profile_image_url"
        case personalReferralCode = "personal_referral_code"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirstLevelKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let email = try container.decode(String.self, forKey: .email)
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        let updatedAt = try container.decode(String.self, forKey: .updatedAt)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let academy = try container.decode(Bool.self, forKey: .academy)
        let role = try container.decode(String.self, forKey: .role)
        let profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        let personalReferralCode = try container.decode(String.self, forKey: .personalReferralCode)
        self.init(id: id, email: email, createdAt: createdAt, updatedAt: updatedAt, firstName: firstName, lastName: lastName, academy: academy, role: role, profileImageUrl: profileImageUrl, personalReferralCode: personalReferralCode)
    }
}
