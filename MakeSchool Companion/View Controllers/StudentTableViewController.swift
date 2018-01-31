//
//  StudentTableViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/17/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class StudentTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
    
    }
    
    var students: [Student] = []
    
    override func viewDidLoad() {
        NetworkingService.getAllStudents { (studentsFromAPI) in
            if let studentsFromAPI = studentsFromAPI {
                self.students = studentsFromAPI
                
                DispatchQueue.main.async {
                    self.tableView.rowHeight = 40
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let student = students[indexPath.row]
            let idView = segue.destination as! IDViewController
            idView.student = student
        }
    }
}

extension StudentTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let student = students[index]
        
        let cell: NameCellView = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! NameCellView
        cell.nameLabel.text = "\(student.firstname!) \(student.lastname!)"
        
        return cell
    }
}

extension StudentTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
