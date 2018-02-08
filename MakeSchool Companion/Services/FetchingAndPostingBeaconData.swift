//
//  FetchingAndPostingBeaconData.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/7/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

enum Route {
    case users()
    case attendances
    
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
        case .attendances:
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
    let session = URLSession.shared
    var baseUrl = "https://make-school-companion.herokuapp.com"
    func fetchBeaconData(route: Route, student: Student? = nil, attendances: AttendancesModel? = nil, requestRoute: DifferentHttpVerbs, completionHandler: @escaping(Data) -> Void) {
        
        let fullUrlString = URL(string: baseUrl.appending(route.path()))
        print("This is the full url string \(fullUrlString!)")
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.addValue("Token token=6c05c1f3c23c4925717c4f21d77c8381", forHTTPHeaderField: "Authorization")
        getRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
//        if student != nil {
//            getRequest.httpBody = route.postBody(users: student, attendances: attendances)
//        }
//        
//        if attendances != nil {
//            getRequest.httpBody = route.postBody(users: student, attendances: attendances)
//        }
        getRequest.httpMethod = requestRoute.rawValue
        
        let task = session.dataTask(with: getRequest) { (data, response, error) in
          
            if let data = data {
                completionHandler(data)
            }
        }
        task.resume()
    }
}
