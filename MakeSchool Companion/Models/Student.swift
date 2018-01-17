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
    
//    let termSeason: String!
//    let termYear: Int!
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case imageURL = "profile_img_url"
        case email
        case portfolio = "slug"
        case termSeason
        case termYear
    }
    
    init(firstname: String, lastname: String, imageURL: String, email: String, portfolio: String) {
        self.firstname = firstname
        self.lastname = lastname
        
        self.imageURL = imageURL
        
        self.email = email
        self.portfolio = portfolio
        
//        self.termSeason = termSeason
//        self.termYear = termYear
    }
    
    init(from decoder: Decoder) throws {
//        var rootContainer = try decoder.unkeyedContainer()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let firstname = try container.decode(String.self, forKey: .firstName)
        let lastname = try container.decode(String.self, forKey: .lastName)
        let imageURL = try container.decode(String.self, forKey: .imageURL)
        let email = try container.decode(String.self, forKey: .email)
        let portfolio = try container.decode(String.self, forKey: .portfolio)
//        let termSeason = try container.decode(String.self, forKey: .termSeason)
//        let termYear = try container.decode(Int.self, forKey: .termYear)
        
        self.init(firstname: firstname, lastname: lastname, imageURL: imageURL, email: email, portfolio: portfolio)
    }
}
