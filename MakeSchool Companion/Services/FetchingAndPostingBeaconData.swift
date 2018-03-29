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
}


enum Route {
    case users(email: String, password: String)
    case facebookLogin
    case attendances(beaconID: String, event: String, eventTime: String)
    
    func path() -> String {
        switch self {
        case .facebookLogin:
            return "https://www.makeschool.com/users/auth/facebook"
        case .attendances:
            return "https://make-school-companion.herokuapp.com/attendances"
        case .users:
            return "https://make-school-companion.herokuapp.com/registrations"
        
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
            
        case .facebookLogin:
            return nil
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
        guard let fullUrlString = URL(string: route.path()) else {return}
        
        var getRequest = URLRequest(url: fullUrlString)
        getRequest.httpMethod = requestRoute.rawValue
        let userToken = keychain.get("Token")
        self.userTokenString = userToken
        
        if route.path() != "https://make-school-companion.herokuapp.com/registrations" && route.path() != "https://www.makeschool.com/users/auth/facebook" {
            getRequest.addValue("Token token=\(self.userTokenString!)", forHTTPHeaderField: "Authorization")
        }
        getRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if requestRoute.rawValue == "POST" {
            getRequest.httpBody = route.postBody()
        }
        
        
        
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
                
            case .facebookLogin:
                print("The reason that we are able to do this is because this facebook login is a redirect therefore there is nothing to decode")
                completionHandler(nil, statusCode)
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



