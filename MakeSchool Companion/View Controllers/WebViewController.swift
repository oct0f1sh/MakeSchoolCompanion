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
import KeychainSwift

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!


    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let keychain = KeychainSwift()
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
            let url = navigationAction.request.url?.absoluteURL
            //handle your events from here

            if url == URL(string: "https://www.makeschool.com/dashboard#_=_") {
                _ = WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                    
                    // Concurrently iterating through the cookies to find specific make school session so that we can grab the make school users object 
                    DispatchQueue.concurrentPerform(iterations: cookies.count, execute: { (cookieIndex) in // How I see this working slower is that if the cookie we are looking for is the first cookie becuase then it is more work to spin the threads up and then check the first cookie then it is to do a lineasr iteration and find it in the first index
                        let cookie = cookies[cookieIndex]
                        if cookie.domain == "www.makeschool.com" && cookie.name == "_makeschool_session"{
                            // Setting the cookie value for the session in keychain
                            keychain.set(cookie.value, forKey: "cookieValue")
                            keychain.set(cookie.domain, forKey: "cookieDomain")
                            keychain.set(cookie.name, forKey: "cookieName")
                            HTTPCookieStorage.shared.setCookie(cookie)

                            showFacebookUserProfile(controller: self, completionHandler: { (response) in
                                searchUsers(controller: self)
                            })
                            return
                        }

                    })
                }
            }
        }
 
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = self.webView

    }
    
    override func viewDidLoad() {
        let navHeight: CGFloat = (self.navigationController?.navigationBar.bounds.height)!
        
        view.frame = CGRect(x: 0, y: navHeight, width: view.frame.width, height: view.frame.height - navHeight)
        
        view.setNeedsLayout()
    }
}
