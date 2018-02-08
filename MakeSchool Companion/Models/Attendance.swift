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
    var user_id: Int?
    var eventTime: String?
    init(beaconID: String?, event: String?, user_id: Int?, event_time: String?) {
        self.beaconID = beaconID
        self.event = event
        self.user_id = user_id
        self.eventTime = event_time
    }
}

extension AttendancesModel {
    enum TopLevelKeys: String, CodingKey {
        case event
        case eventTime = "event_time"
        case beaconID = "beacon_id"
        case user_id
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: TopLevelKeys.self)
        let event = try container?.decodeIfPresent(String.self, forKey: .event)
        let eventTime = try? container?.decodeIfPresent(String.self, forKey: .eventTime)
        let beaconID = try? container?.decodeIfPresent(String.self, forKey: .beaconID)
        let user_id = try? container?.decodeIfPresent(Int.self, forKey: .user_id)
        self.init(beaconID: beaconID!, event: event!, user_id: user_id!, event_time: eventTime!)
    }
}
