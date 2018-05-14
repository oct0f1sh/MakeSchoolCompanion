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
    var beacon_id: String
    var event: String
    var event_time: String
    init(beacon_id: String, event: String, event_time: String) {
        self.beacon_id = beacon_id
        self.event = event
        self.event_time = event_time
    }
    
}

extension AttendancesModel {
    enum TopLevelKeys: String, CodingKey {
        case event
        case event_time = "event_time"
        case beacon_id = "beacon_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelKeys.self)
        let event = try container.decodeIfPresent(String.self, forKey: .event) ?? "No event present"
        let event_time = try container.decodeIfPresent(String.self, forKey: .event_time) ?? "No event time given"
        let beacon_id = try container.decodeIfPresent(String.self, forKey: .beacon_id) ?? "No beacon id given"
        self.init(beacon_id: beacon_id , event: event, event_time: event_time )
    }
}
