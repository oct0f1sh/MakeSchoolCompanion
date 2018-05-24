//
//  RootViewController.swift
//  MakeSchool Companion
//
//  Created by Duncan MacDonald on 2/13/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
