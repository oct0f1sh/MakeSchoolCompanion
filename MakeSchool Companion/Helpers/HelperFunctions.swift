//
//  HelperFunctions.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/9/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import Moya

var student: Student! = nil


//func fetchIdentification () -> [Int] {
//    fetchStudentIdentification(target: .myStudents, success: { (success) in
//        var json = try? success.mapJSON()
//    }, error: { (error) in
//        print(error)
//    }, failure: { (moyaError) in
//        print(moyaError)
//    })
//    return json
//}

//func downloadPortfolioImage() {
//    NetworkingService.downloadImage(imgUrl: student.imageURL) { (img) in
//        if let img = img {
//            student.image = img
//            
//            DispatchQueue.main.async {
//                updateStudent(student: student)
//            }
//        }
//    }
//}

