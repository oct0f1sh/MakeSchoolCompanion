//
//  ViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import UIKit
import CoreLocation

class IDViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailDomain: UILabel!
    @IBOutlet weak var portfolioLabel: UILabel!
    
    @IBOutlet weak var termSeasonLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var testLabel: UILabel!
    
    var student: Student! = nil
    
    override func viewDidLoad() {
        AppDelegate.shared.beaconManager.delegate = self
        var beacon = AppDelegate.shared.beaconManager
        
        NetworkingService.downloadImage(imgUrl: student.imageURL) { (img) in
            if let img = img {
                self.student.image = img
                
                DispatchQueue.main.async {
                    self.updateStudent(student: self.student)
                }
            }
        }
        switch AppDelegate.shared.beaconManager.status {
        case .enteredBeaconRange:
            testLabel.text = "entered beacon region: \(beacon.beaconRegion.identifier)"
        case .exitedBeaconRange:
            testLabel.text = "exited beacon region: \(beacon.beaconRegion.identifier)"
        case .inBeaconRange:
            testLabel.text = "in range of beacon: \(beacon.beaconRegion.identifier)"
        case .notInBeaconRange:
            testLabel.text = "not in beacon range"
        case .searching:
            testLabel.text = "searching..."
        case .started:
            testLabel.text = "started beacon manager"
        }
    }
    
    
    func updateStudent(student: Student) {
        let splitEmail = student.email.components(separatedBy: "@")
        let emailPrefix = splitEmail[0]
        let emailDomain = splitEmail[1]
        
        self.profileImageView.image = student.image
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderWidth = 5
        self.profileImageView.layer.borderColor = UIColor(red: 74, green: 74, blue: 74, alpha: 74).cgColor
        
        self.firstnameLabel.text = student.firstname
        self.lastnameLabel.text = student.lastname
        
        self.emailLabel.text = emailPrefix
        self.emailDomain.text = "@\(emailDomain)"
        self.portfolioLabel.text = "portfolio/\(student.portfolio!)"
        
        self.termSeasonLabel.text = "SPRING"
        self.yearLabel.text = "2018"
    }
}

extension IDViewController: BeaconManagerDelegate {
    func beaconManager(sender: BeaconManager, isInBeaconRange region: CLRegion) {
        testLabel.text = "in range of beacon: \(region.identifier)"
    }
    
    func beaconManager(sender: BeaconManager, isNotInBeaconRange region: CLRegion) {
        testLabel.text = "not in beacon range"
    }
    
    func beaconManager(sender: BeaconManager, searchingInRegion region: CLRegion) {
        testLabel.text = "searching..."
    }
    
    func beaconManager(sender: BeaconManager, enteredBeaconRegion region: CLRegion) {
        testLabel.text = "entered beacon region: \(region.identifier)"
    }
    
    func beaconManager(sender: BeaconManager, exitedBeaconRegion region: CLRegion) {
        testLabel.text = "exited beacon region: \(region.identifier)"
    }
}
