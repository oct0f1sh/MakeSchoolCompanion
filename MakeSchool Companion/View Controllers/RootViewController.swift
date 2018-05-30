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
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        switch self.stackView.frame.origin.x {
        case -1000...0:
            self.animateStackView(.right, shouldPerformSegue: false)
        default:
//            self.animateStackView(.left, shouldPerformSegue: false)
            break
        }
    }
    
    func animateStackView(_ direction: AnimationDirection, shouldPerformSegue: Bool) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            if direction == .left {
                self.stackView.frame.origin.x -= 400
            } else if direction == .right {
                self.stackView.frame.origin.x += 400
            }
        }) { _ in
            if shouldPerformSegue {
                self.performSegue(withIdentifier: "emailLoginSegue", sender: self)
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.performSegue(withIdentifier: "facebookLoginSegue", sender: self)
        default:
            self.animateStackView(.left, shouldPerformSegue: true)
        }
    }
}

enum AnimationDirection {
    case up
    case down
    case left
    case right
}
