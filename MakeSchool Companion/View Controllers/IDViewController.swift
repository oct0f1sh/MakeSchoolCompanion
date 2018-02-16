//
//  ViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/12/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import UIKit
import CoreLocation
import KeychainSwift

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
    
    var identificationNumbers = [Any]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AppDelegate.shared.beaconManager.delegate = self
        var beacon = AppDelegate.shared.beaconManager
        
        let keychain = KeychainSwift()
        let profileImageURL = URL(string: keychain.get("ImageURL")!)
        let data = try? Data(contentsOf: profileImageURL!)
        profileImageView.image = UIImage(data: data!)
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderWidth = 5
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        emailLabel.text = keychain.get("email")
        portfolioLabel.text = keychain.get("portfolio")
        firstnameLabel.text = keychain.get("firstName")
        lastnameLabel.text = keychain.get("lastName")
        
        
        fetchStudentIdentification(target: .myStudents, success: { (success) in
            guard let json = try? success.mapJSON() else {return}
            for element in json as! [AnyObject]{
                self.identificationNumbers.append(element)
            }
            print(self.identificationNumbers)
            
            
        }, error: { (error) in
            print(error)
        }, failure: { (moyaError) in
            print(moyaError)
        })
        
        switch AppDelegate.shared.beaconManager.status {
        case .enteredBeaconRange:
            testLabel.text = "entered beacon region: \(beacon.beaconRegion.identifier)"
        case .exitedBeaconRange:
            testLabel.text = "exited beacon region: \(beacon.beaconRegion.identifier)"
        case .inBeaconRange:
            testLabel.text = "📡✅"
        case .notInBeaconRange:
            testLabel.text = "📡❌"
        case .searching:
            testLabel.text = "📡🌀"
        case .started:
            testLabel.text = "started beacon manager"
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func updateStudent(student: Student) {
        let keychain = KeychainSwift()
        let splitEmail = keychain.get("email")?.components(separatedBy: "@")
        let emailPrefix = splitEmail![0]
        let emailDomain = splitEmail![1]
        
        self.profileImageView.image = student.image
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderWidth = 5
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        self.firstnameLabel.text = student.firstname
        self.lastnameLabel.text = student.lastname
        
        self.emailLabel.text = emailPrefix
        
        self.emailDomain.text = emailDomain
        self.portfolioLabel.text = "portfolio/\(student.portfolio!)"
        
        self.termSeasonLabel.text = "SPRING"
        self.yearLabel.text = "2018"
    }
}

extension IDViewController: BeaconManagerDelegate {
    func beaconManager(sender: BeaconManager, isInBeaconRange region: CLRegion) {
        testLabel.text = "📡✅"
    }
    
    func beaconManager(sender: BeaconManager, isNotInBeaconRange region: CLRegion) {
        testLabel.text = "📡❌"
    }
    
    func beaconManager(sender: BeaconManager, searchingInRegion region: CLRegion) {
        testLabel.text = "📡🌀"
    }
    
    func beaconManager(sender: BeaconManager, enteredBeaconRegion region: CLRegion) {
        testLabel.text = "entered beacon region: \(region.identifier)"
    }
    
    func beaconManager(sender: BeaconManager, exitedBeaconRegion region: CLRegion) {
        testLabel.text = "exited beacon region: \(region.identifier)"
    }
}
