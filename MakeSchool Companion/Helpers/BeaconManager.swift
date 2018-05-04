//
//  BeaconManager.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 1/31/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class BeaconManager: NSObject, CLLocationManagerDelegate {
    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var isSearchingForBeacons = true
    var status: BeaconStatus = .started
    
    weak var delegate: BeaconManagerDelegate?
    
    var beaconLogic = BeaconNetworkingLayer()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let uuid = UUID(uuidString: "BC93FB2E-6CFA-4A8E-BDAE-0D2664F9216F")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 7527, minor: 8551, identifier: "test beacon")
        
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        if isSearchingForBeacons {
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("The user is in the beacon range")
        EmailandPasswordandToken.beaconId = "Test Beacon"
        EmailandPasswordandToken.event = String(describing: status)
        EmailandPasswordandToken.eventTime = printTimestamp()
        
        beaconLogic.fetchBeaconData(route: .attendances(beaconID: EmailandPasswordandToken.beaconId, event: String(describing: status), eventTime: printTimestamp()), completionHandler: { (attendance, response) in
            print("This is the response from the user entering the beacon region \(response)")
        }, requestRoute: .postReuqest)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: beaconRegion)
        delegate?.beaconManager(sender: self, searchingInRegion: region)
        print("started monitoring for beacons")
        status = .searching
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
     
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegate?.beaconManager(sender: self, enteredBeaconRegion: region)
        print(region)
        status = .enteredBeaconRange
        EmailandPasswordandToken.beaconId = "Test Beacon"
        EmailandPasswordandToken.event = String(describing: status)
        EmailandPasswordandToken.eventTime = printTimestamp()
        print("The user has entered the beacon range")
        beaconLogic.fetchBeaconData(route: .attendances(beaconID: "Test Beacon", event: String(describing: status), eventTime: printTimestamp()), completionHandler: { (attendance, response) in
            print("This is the response from the user entering the beacon region \(response)")
        }, requestRoute: .postReuqest)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.beaconManager(sender: self, exitedBeaconRegion: region)
        status = .exitedBeaconRange
        EmailandPasswordandToken.beaconId = "Test Beacon"
        EmailandPasswordandToken.event = String(describing: status)
        EmailandPasswordandToken.eventTime = printTimestamp()
        print("The user exited the beacon range")
        beaconLogic.fetchBeaconData(route: .attendances(beaconID: "Test Beacon", event: String(describing: status), eventTime: printTimestamp()), completionHandler: { (attendance, response) in
            print("This is the response from the user exiting the beacon region \(response)")
        }, requestRoute: .postReuqest)
    }
}
protocol BeaconManagerDelegate: class {
    func beaconManager(sender: BeaconManager, isInBeaconRange region: CLRegion)
    func beaconManager(sender: BeaconManager, isNotInBeaconRange region: CLRegion)
    func beaconManager(sender: BeaconManager, searchingInRegion region: CLRegion)
    func beaconManager(sender: BeaconManager, enteredBeaconRegion region: CLRegion)
    func beaconManager(sender: BeaconManager, exitedBeaconRegion region: CLRegion)
}

enum BeaconStatus {
    case started
    case inBeaconRange
    case notInBeaconRange
    case searching
    case enteredBeaconRange
    case exitedBeaconRange
}


func printTimestamp() -> String {
    let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .long)
    return timestamp
}
