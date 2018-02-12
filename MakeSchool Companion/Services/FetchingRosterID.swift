//
//  FetchingRosterID.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/9/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import Moya


//
//class FetchStudentIdentification {
//    let session = URLSession.shared
//    var baseUrl = URL(string:"https://staging.makeschool.com/api/rosters/current-students")
//    func fetchStudentIdentification(completionHandler: @escaping(Data) -> Void) {
//        session.dataTask(with: baseUrl!) { (data, response, error) in
//            completionHandler(data!)
//        }
//    }
//}

enum StudentIdentification {
    case myStudents
}

extension StudentIdentification: TargetType {
    var baseURL: URL {
        let baseURL = URL(string:"https://staging.makeschool.com/api/rosters/current-students")
        return baseURL!
    }
    
    var path: String {
        switch self {
        case .myStudents:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myStudents:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .myStudents:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .myStudents:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

func fetchStudentIdentification(target: StudentIdentification, success successCallBack: @escaping(Response) -> Void, error errorCallBack: @escaping(Swift.Error) -> Void, failure failureCallBack: @escaping(MoyaError) -> Void) {
    let provider = MoyaProvider<StudentIdentification>()
    provider.request(target) { (result) in
        switch result {
        case .failure(let error):
            errorCallBack(error)
        case .success(let response):
            if response.statusCode >= 200 && response.statusCode <= 300 {
                successCallBack(response)

            }
            
        }
    }
}
