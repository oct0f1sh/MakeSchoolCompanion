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
    var lastFoundBeacon: CLBeacon = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.unknown
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        let uuid = UUID(uuidString: "BC93FB2E-6CFA-4A8E-BDAE-0D2664F9216F")
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 7527, minor: 8551, identifier: "us.duncanmacdonald.MakeSchool-Companion")
        
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        if isSearchingForBeacons {
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: beaconRegion)
//        testLabel.text = "searching..."
        print("started monitoring for beacons")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside {
            print("device is inside beacon region")
//            testLabel.text = "inside beacon region"
            locationManager.startRangingBeacons(in: beaconRegion)
        } else {
            print("not inside beacon region")
//            testLabel.text = "not in beacon region"
            //locationManager.stopRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        testLabel.text = "entered"
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        testLabel.text = "exited"
    }
}
