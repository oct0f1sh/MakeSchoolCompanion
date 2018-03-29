//
//  WebViewController.swift
//  MakeSchool Companion
//
//  Created by Matthew Harrilal on 3/27/18.
//  Copyright © 2018 Duncan MacDonald. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let url = "https://www.makeschool.com/users/auth/facebook"
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)
        
        
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
