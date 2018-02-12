//
//  FetchingAndPostingBeaconData.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/7/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct DynamicToken {
    static var token = ""
}

enum Route {
    case users
    case attendances
    
    func path() -> String {
        switch self {
        case .attendances:
            return "/attendances"
        case .users:
            return "/users"
        }
    }
    func postBody(users: SignUserUp? = nil, attendances: AttendancesModel?=nil) -> Data? {
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
                print(jsonBody.base64EncodedString())
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
    let session = URLSession.shared
    var baseUrl = "https://make-school-companion.herokuapp.com"
    func fetchBeaconData(route: Route, user: SignUserUp? = nil, attendances: AttendancesModel? = nil, completionHandler: @escaping(Data) -> Void, requestRoute: DifferentHttpVerbs) {
        
        var fullUrlString = URL(string: baseUrl.appending(route.path()))
        
//        fullUrlString?.appendingQueryParameters(["id": "1"])

        print("This is the full url string \(fullUrlString!)")
        var getRequest = URLRequest(url: fullUrlString!)
        if getRequest.httpMethod != "POST" {
          getRequest.addValue("Token token=\(DynamicToken.token)", forHTTPHeaderField: "Authorization")
        }

        getRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        getRequest.httpMethod = requestRoute.rawValue
        if user != nil {
            getRequest.httpBody = route.postBody(users: user)
        }
        
        if attendances != nil {
            getRequest.httpBody = route.postBody(attendances: attendances)
        }
        

        let task = session.dataTask(with: getRequest) { (data, response, error) in
            print("This is the data from the log in \(data?.base64EncodedString())")
            completionHandler(data!)
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



