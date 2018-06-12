//
//  NetworkingService.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class NetworkingService {
    static func getAllStudents(completion: @escaping ([Student]) -> Void) {
        let url = URL(string: "https://www.makeschool.com/portfolios.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "Error thrown when fetching all students")
                return
            }
            
            if let data = data {
                guard let students = try? JSONDecoder().decode([Student].self, from: data) else {return}
                completion(students)
            }
        }
        task.resume()
    }
   
}
