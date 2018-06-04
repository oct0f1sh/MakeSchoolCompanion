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
import WebKit

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
     
        
        
    }
    @IBAction func logoutButton(_ sender: UIButton) {
        print("The user has pressed the log out button")
       
//        self.present(testLoginViewContoller, animated: true, completion: nil)
        print("These are the navigation controllers \(self.navigationController?.viewControllers)")
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: {
                print("Deleted records \(records)") // Clearing cookies so when the user logs back into facebook they are not logged into their dashboard already
                let testLoginViewContoller = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "TestLogInViewController") as! TestLoginViewController
                self.dismiss(animated: true) {
                    print("The view was dismissed")
                } // Then present the new view
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.shared.beaconManager.delegate = self
        let beacon = AppDelegate.shared.beaconManager
        _ = BeaconManager()
        let keychain = KeychainSwift()
        let profileString = keychain.get("profileImageUrl")!
        let profileImageURL = URL(string: profileString)
        let data = try? Data(contentsOf: profileImageURL!)
        profileImageView.image = UIImage(data: data!)
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderWidth = 5
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
            
        firstnameLabel.text = keychain.get("firstName")
        lastnameLabel.text = keychain.get("lastName")
        
        
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
        testLabel.text = "📡✅"
    }
    
    func beaconManager(sender: BeaconManager, exitedBeaconRegion region: CLRegion) {
        testLabel.text = "📡❌"
    }
}
