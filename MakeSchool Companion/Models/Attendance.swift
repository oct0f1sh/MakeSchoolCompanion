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
    var beaconID: String?
    var event: String?
    var eventTime: String?
    init(beaconID: String?, event: String?, eventTime: String?) {
        self.beaconID = beaconID
        self.event = event
        self.eventTime = eventTime
    }
}

extension AttendancesModel {
    enum TopLevelKeys: String, CodingKey {
        case event
        case eventTime = "event_time"
        case BeaconID = "beacon_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: TopLevelKeys.self)
        let event = try container?.decodeIfPresent(String.self, forKey: .event)
        let eventTime = try? container?.decodeIfPresent(String.self, forKey: .eventTime)
        let beaconID = try? container?.decodeIfPresent(String.self, forKey: .BeaconID)
        self.init(beaconID: beaconID!, event: event!, eventTime: eventTime!)
    }
}
