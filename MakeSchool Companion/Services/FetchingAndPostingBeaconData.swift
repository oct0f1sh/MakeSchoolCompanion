//
//  FetchingAndPostingBeaconData.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/7/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

struct EmailandPasswordandToken {
    static var email = ""
    static var password = ""
    static var token = ""
    static var event = ""
    static var eventTime = ""
    static var beaconId = ""
}


enum Route {
    case users(email: String, password: String)
    case attendances(beaconID: String, event: String, eventTime: String)
    case facebookCallback(email: String, firstName: String, lastName: String, imageUrl: String)
    case searchUsers(email: String)
    
    func path() -> String {
        switch self {
        case .attendances:
            return "https://make-school-companion.herokuapp.com/attendances?event=\(EmailandPasswordandToken.event)&event_time=\(EmailandPasswordandToken.eventTime)&beacon_id=\(EmailandPasswordandToken.beaconId)"
        case .users:
            return "https://make-school-companion.herokuapp.com/registrations/?email=\(EmailandPasswordandToken.email)&password=\(EmailandPasswordandToken.password)"
        case .facebookCallback:
            return "https://make-school-companion.herokuapp.com/users?email=\(StaticProperties.email)&first_name=\(StaticProperties.firstName)&last_name=\(StaticProperties.lastName)&image_url=\(StaticProperties.imageUrl)"
        case .searchUsers:
            return "https://make-school-companion.herokuapp.com/users?email=\(StaticProperties.email)"
        }
        
    }
    func postBody() -> Data? {
        switch self {
        case let .users(email, password):
            let json = ["email": email, "password": password]
            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
            return data
            
        case let .attendances(beaconId, event, eventTime):
            let json = ["beacon_id": beaconId, "event": event, "event_time": eventTime]
            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
            return data
            
        case let .facebookCallback(email, firstName, lastName, imageUrl):
//            let json = ["email": email, "first_name": firstName, "last_name": lastName, "image_url": imageUrl]
//            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
            return Data()
        case .searchUsers(let email):
            return Data()
        }
    }
}

enum DifferentHttpVerbs: String {
    case getRequest = "GET"
    case postReuqest = "POST"
}

class BeaconNetworkingLayer {
    var userTokenString: String!
    
    let session = URLSession.shared
    func fetchBeaconData(route: Route, completionHandler: @escaping(Any?, Int) -> Void, requestRoute: DifferentHttpVerbs) {
        let keychain = KeychainSwift()
        let fullUrlString = URL(string: route.path().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.httpMethod = requestRoute.rawValue
        let userToken = keychain.get("Token")
        self.userTokenString = userToken
        getRequest.httpBody = route.postBody()
        
        if route.path() != "https://make-school-companion.herokuapp.com/registrations" && route.path() != "https://www.makeschool.com/users/auth/facebook" && route.path() != "https://make-school-companion.herokuapp.com/users?email=\(StaticProperties.email)&first_name=\(StaticProperties.firstName)&last_name=\(StaticProperties.lastName)&image_url=\(StaticProperties.imageUrl)" && route.path() != "https://make-school-companion.herokuapp.com/users?email=\(StaticProperties.email)" {
            getRequest.addValue("Token token=\(self.userTokenString!)", forHTTPHeaderField: "Authorization")
        }
        getRequest.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
//        if requestRoute.rawValue == "POST" && route.path() != "https://make-school-companion.herokuapp.com/users?email=\(StaticProperties.email)&first_name=\(StaticProperties.firstName)&last_name=\(StaticProperties.lastName)&image_url=\(StaticProperties.imageUrl)" {
//            getRequest.httpBody = route.postBody()
//        }
        
        
        
        session.dataTask(with: getRequest) { (data, response, error) in
            let statusCode: Int = (response as! HTTPURLResponse).statusCode
            switch route {
            case .users:
                guard let decodedUser = try? JSONDecoder().decode(MSUserModelObject.self, from: data!) else {return}
                keychain.set(decodedUser.imageUrl, forKey: "profileImageUrl")
                keychain.set(decodedUser.email, forKey: "email")
                keychain.set(decodedUser.firstName, forKey: "firstName")
                keychain.set(decodedUser.lastName, forKey: "lastName")
                keychain.set(decodedUser.token, forKey: "Token")
                keychain.set(decodedUser.id, forKey: "id")
                
                completionHandler(decodedUser, statusCode)
            case .attendances:
                guard let decodedAttendance = try? JSONDecoder().decode(AttendancesModel.self, from: data!) else {return}
                completionHandler(decodedAttendance, statusCode)
                
            case .facebookCallback:
                guard let decodedUser = try? JSONDecoder().decode(MSUserModelObject.self, from: data!) else {return}
                keychain.set(decodedUser.imageUrl, forKey: "profileImageUrl")
                keychain.set(decodedUser.email, forKey: "email")
                keychain.set(decodedUser.firstName, forKey: "firstName")
                keychain.set(decodedUser.lastName, forKey: "lastName")
                keychain.set(decodedUser.token, forKey: "Token")
                keychain.set(decodedUser.id, forKey: "id")
                completionHandler(decodedUser, statusCode)
            case .searchUsers:
                if let decodedUser = try? JSONDecoder().decode(MSUserModelObject.self, from: data!) {
                    keychain.set(decodedUser.imageUrl, forKey: "profileImageUrl")
                    keychain.set(decodedUser.email, forKey: "email")
                    keychain.set(decodedUser.firstName, forKey: "firstName")
                    keychain.set(decodedUser.lastName, forKey: "lastName")
                    keychain.set(decodedUser.token, forKey: "Token")
                    keychain.set(decodedUser.id, forKey: "id")
                }
                
                else {
                    keychain.set("", forKey: "profileImageUrl")
                    keychain.set("", forKey: "email")
                    keychain.set("", forKey: "firstName")
                    keychain.set("", forKey: "lastName")
                    keychain.set("", forKey: "Token")
                    keychain.set("", forKey: "id")
                }
            }
            }.resume()
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}



