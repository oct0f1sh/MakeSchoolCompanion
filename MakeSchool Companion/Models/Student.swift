//
//  Student.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct Student: Decodable {
    let firstname: String!
    let lastname: String!
    
    let imageURL: String!
    var image: UIImage?
    
    let email: String!
    let portfolio: String!
    
    var userID: Int?
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case imageURL = "profile_img_url"
        case email
        case portfolio = "slug"
        case termSeason
        case termYear
        case user_id
    }
    
    init(firstname: String, lastname: String, imageURL: String, email: String, portfolio: String, userID: Int?) {
        self.firstname = firstname
        self.lastname = lastname
        
        self.imageURL = imageURL
        
        self.email = email
        self.portfolio = portfolio
        
        self.userID = userID
        

    }
    
    init(from decoder: Decoder) throws {
//        var rootContainer = try decoder.unkeyedContainer()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let firstname = try container.decode(String.self, forKey: .firstName)
        let lastname = try container.decode(String.self, forKey: .lastName)
        let imageURL = try container.decode(String.self, forKey: .imageURL)
        let email = try container.decode(String.self, forKey: .email)
        let portfolio = try container.decode(String.self, forKey: .portfolio)
        let user_id = try? container.decodeIfPresent(Int.self, forKey: .user_id)
        self.init(firstname: firstname, lastname: lastname, imageURL: imageURL, email: email, portfolio: portfolio, userID: user_id!)
    }
}
