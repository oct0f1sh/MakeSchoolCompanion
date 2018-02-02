//
//  Style.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 2/2/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    struct Colors {
        static let makeDarkBlue = UIColor(red: 23/255, green: 156/255, blue: 215/255, alpha: 1.0)
        static let makeLightBlue = UIColor(red: 153/255, green: 211/255, blue: 237/255, alpha: 1.0)
        static let makeGray = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        static let makeRed = UIColor(red: 209/255, green: 28/255, blue: 45/255, alpha: 1.0)
    }
    
    struct Fonts {
        static let smallNova = UIFont(name: "ProximaNova", size: 24.0)
        static let bigNova = UIFont(name: "ProximaNova", size: 36.0)
    }
}
