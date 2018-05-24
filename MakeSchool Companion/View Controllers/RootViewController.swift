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
            self.animateStackView(nil, .right)
        default:
            self.animateStackView(nil, .left)
        }
    }
    
    func animateStackView(_ sender: UIButton?, _ direction: AnimationDirection) {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            if direction == .left {
                self.stackView.frame.origin.x -= 400
            } else if direction == .right {
                self.stackView.frame.origin.x += 400
            }
        }) { _ in
            if let button = sender {
            switch button.tag {
                case 0:
                    self.performSegue(withIdentifier: "facebookLoginSegue", sender: self)
                case 1:
                    self.performSegue(withIdentifier: "emailLoginSegue", sender: self)
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.animateStackView(sender, .left)
    }
}

enum AnimationDirection {
    case up
    case down
    case left
    case right
}
