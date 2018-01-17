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
    static func getAllStudents(completion: @escaping ([Student]?) -> Void) {
        let url = URL(string: "https://www.makeschool.com/portfolios.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                let students = try? JSONDecoder().decode([Student].self, from: data)
                completion(students)
            }
        }
        task.resume()
    }
    
    static func getStudent(completion: @escaping (Student?) -> Void) {
        let url = URL(string: "https://www.makeschool.com/portfolios/erick-sanchez-estrada.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                let student = try? JSONDecoder().decode(Student.self, from: data)
                completion(student)
            }
        }
        task.resume()
    }
    
    static func downloadImage(imgUrl: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: imgUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }
        task.resume()
    }
}
