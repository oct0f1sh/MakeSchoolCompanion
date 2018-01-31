//
//  ViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import UIKit
import CoreLocation

class IDViewController: UIViewController, CLLocationManagerDelegate {
    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var isSearchingForBeacons = true
    var lastFoundBeacon: CLBeacon = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.unknown
    
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
        NetworkingService.downloadImage(imgUrl: student.imageURL) { (img) in
            if let img = img {
                self.student.image = img
                
                DispatchQueue.main.async {
                    self.updateStudent(student: self.student)
                }
            }
        }
        
        // BEACON INITIALIZATION
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let uuid = UUID(uuidString: "BC93FB2E-6CFA-4A8E-BDAE-0D2664F9216F")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 7527, minor: 8551, identifier: "us.duncanmacdonald.MakeSchool-Companion")
//        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "us.duncanmacdonald.MakeSchool-Companion")
        
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        // END BEACON INITIALIZATION
        
        // BEACON CHECKING
        if isSearchingForBeacons {
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startUpdatingLocation()
        }
        // END BEACON CHECKING
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: beaconRegion)
        testLabel.text = "searching..."
        print("started monitoring for beacons")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside {
            print("device is inside beacon region")
            testLabel.text = "inside beacon region"
            locationManager.startRangingBeacons(in: beaconRegion)
        } else {
            print("not inside beacon region")
            testLabel.text = "not in beacon region"
            //locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        testLabel.text = "entered"
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        testLabel.text = "exited"
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

