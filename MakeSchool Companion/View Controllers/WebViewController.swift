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

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton()
    }
    
  
    
    func backButton() {
        let image = UIImage(named: "icon-back") as UIImage?
        let button = UIButton(type: UIButtonType.custom) as UIButton
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        button.frame = CGRect(x:screenWidth * 0.85, y:screenHeight * 0.90, width:56, height:56) // (X, Y, Height, Width)
        button.setImage(image, for: .normal)
        button.addTarget(self, action:#selector(customGoBack(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func customGoBack(sender: UIButton) {
        if self.webView.canGoBack {
            print("Can go back")
            self.webView.goBack()
            self.webView.reload()
        } else {
            let storage = WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                for cookie in cookies {
                    if cookie.domain == "www.makeschool.com" && cookie.name == "_makeschool_session"{
                        // Setting the cookie value for the session in keychain
                        keychain.set(cookie.value, forKey: "cookieValue")
                        keychain.set(cookie.domain, forKey: "cookieDomain")
                        keychain.set(cookie.name, forKey: "cookieName")
                        HTTPCookieStorage.shared.setCookie(cookie)
                        showFacebookUserProfile()
                    }
                }
            }
            print("This is the value for the make school cookie \(storage)")
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
    
    func webViewDidClose(_ webView: WKWebView) {
        print("The web view did close")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
     
    }
}

extension WebViewController: UIWebViewDelegate {
    
}
