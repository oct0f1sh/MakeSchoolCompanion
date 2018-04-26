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
        
        var timer = Timer.scheduledTimer(withTimeInterval: 35.0, repeats: false) { (timer) in
             print(timer.timeInterval)
            if timer.timeInterval == 0 {
               
               
                var getRequest = URLRequest(url: URL(string: "http://www.makeschool.com/login.json")!)
                getRequest.httpMethod = "POST"
                let session = URLSession.shared
//                let headers = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies!)
//
//              
                let headers = ["Authorization": "Token \(keychain.get("cookieValue")!)"]
                getRequest.allHTTPHeaderFields = headers
                session.dataTask(with: getRequest, completionHandler: { (data, response, error) in
//                    for cookie in HTTPCookieStorage.shared.cookies! {
//                        if cookie.name == "_makeschool_session" {
//                            print("This is the cookie value \(cookie.value)")
//                            keychain.set(cookie.value, forKey: "cookieValue")
//                        }
//                    }
                    print(data?.base64EncodedString(), response)
                }).resume()
                
            
            }
        }
        
        
    }
    
    // must be internal or public.
    @objc func update() {
        // Something cool
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let url = "https://www.makeschool.com/users/auth/facebook"
        var request = URLRequest(url: URL(string: url)!)
        webView.load(request)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "_makeschool_session" {
                    keychain.set(cookie.value, forKey: "cookieValue")
                }
            }
        }
    }
}

extension WebViewController: UIWebViewDelegate {
    
}
