//
//  Attendance.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 2/7/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct AttendancesModel: Codable {
    var date = Date()
    var beaconID: String?
    var event: String?
    var eventTime: String?
    init(beaconID: String?, event: String?) {
        self.beaconID = beaconID
        self.event = event
        self.eventTime = printTimestamp()
    }
}

extension AttendancesModel {
    enum TopLevelKeys: String, CodingKey {
        case event
        case eventTime = "event_time"
        case beaconID = "beacon_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: TopLevelKeys.self)
        let event = try container?.decodeIfPresent(String.self, forKey: .event)
        let eventTime = try? container?.decodeIfPresent(String.self, forKey: .eventTime)
        let beaconID = try? container?.decodeIfPresent(String.self, forKey: .beaconID)
        self.init(beaconID: beaconID!, event: event!)
    }
}
