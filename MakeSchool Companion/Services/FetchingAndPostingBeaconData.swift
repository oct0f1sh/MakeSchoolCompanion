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
    case users
    case attendances
    case signUp
    
    func path() -> String {
        switch self {
        case .attendances:
            return "/attendances"
        case .users:
//            return "/active_sessions?email=\(EmailandPasswordandToken.email)&password=\(EmailandPasswordandToken.password)"
            return "/registrations"
        case .signUp:
            return "/registrations"
        }
        
    }
    func postBody(users: ActiveUser? = nil, attendances: AttendancesModel?=nil) -> Data? {
        switch self {
        case .attendances:
            var jsonBody = Data()
            do {
                jsonBody = try! JSONEncoder().encode(attendances)
            }
            return jsonBody
        case .users:
            var jsonBody = Data()
            do {
                jsonBody = try! JSONEncoder().encode(users)
            }
            return jsonBody
            
        case .signUp:
            var jsonBody = Data()
            do {
                jsonBody = try! JSONEncoder().encode(users)
            }
            return jsonBody
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
    var baseUrl = "https://make-school-companion.herokuapp.com"
    func fetchBeaconData(route: Route, student: ActiveUser? = nil, attendances: AttendancesModel? = nil, completionHandler: @escaping(Data, Int) -> Void, requestRoute: DifferentHttpVerbs) {
        let keychain = KeychainSwift()
        var fullUrlString = URL(string: baseUrl.appending(route.path()))
        
        
        print("This is the full url string \(fullUrlString!)")
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.httpMethod = requestRoute.rawValue
        var userToken = keychain.get("Token")
        self.userTokenString = userToken
        
        if getRequest.httpMethod != "GET" {
            getRequest.addValue("Token token=\(self.userTokenString!)", forHTTPHeaderField: "Authorization")
        }
        getRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        getRequest.httpMethod = requestRoute.rawValue
        if student != nil {
            getRequest.httpBody = route.postBody(users: student)
        }
        
        if attendances != nil {
            getRequest.httpBody = route.postBody(attendances: attendances)
        }
        
        
        let task = session.dataTask(with: getRequest) { (data, response, error) in
            let statusCode: Int = (response as! HTTPURLResponse).statusCode
            print(response)
            completionHandler(data!, statusCode)
        }
        task.resume()
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



