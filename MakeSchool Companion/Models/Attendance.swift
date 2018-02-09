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
    var id: String
    init(beacon_id: String, event: String, event_time: String, id: String) {
        self.beacon_id = beacon_id
        self.event = event
        self.event_time = event_time
        self.id = id
    }
    
}

extension AttendancesModel {
    enum TopLevelKeys: String, CodingKey {
        case event
        case event_time = "event_time"
        case beacon_id = "beacon_id"
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: TopLevelKeys.self)
        let event = try container?.decodeIfPresent(String.self, forKey: .event)
        let event_time = try? container?.decodeIfPresent(String.self, forKey: .event_time)
        let beacon_id = try? container?.decodeIfPresent(String.self, forKey: .beacon_id)
        let id = try? container?.decodeIfPresent(String.self, forKey: .id)
        self.init(beacon_id: beacon_id as! String, event: event!, event_time: event_time as! String, id: id as! String)
    }
}
