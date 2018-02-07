//
//  FetchingAndPostingBeaconData.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/7/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

let session = URLSession.shared

enum Route {
    case users()
    case attendances()
    
    func path() -> String {
        switch self {
        case .attendances:
            return "/attendances"
        case .users:
            return "/users"
        }
    }
    func postBody(users: Student? = nil, attendances: AttendancesModel?=nil) -> Data? {
        switch self {
        case .attendances():
            var jsonBody = Data()
            do {
                jsonBody = try! JSONEncoder().encode(attendances)
            }
            return jsonBody
        case .users():
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
    var baseUrl = "http://localhost:3000"
    func fetchBeaconData(route: Route, student: Student? = nil, attendances: AttendancesModel? = nil, requestRoute: DifferentHttpVerbs, completionHandler: @escaping(Data) -> Void) {
        
        var fullUrlString = URL(string: baseUrl.appending(route.path()))
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.addValue("Token token=3cc3345b2fdfe38c7fe0cf46f4ee7a86", forHTTPHeaderField: "Authorization")
        getRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if student != nil {
            getRequest.httpBody = route.postBody(users: student, attendances: attendances)
        }
        
        if attendances != nil {
            getRequest.httpBody = route.postBody(users: student, attendances: attendances)
        }
        getRequest.httpMethod = requestRoute.rawValue
        
        session.dataTask(with: getRequest) { (data, response, error) in
          
            print(response)
            if let data = data {
                print(response)
                completionHandler(data)
            }
        }.resume()
    }
}
