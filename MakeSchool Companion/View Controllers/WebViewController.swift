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
    
 
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
            let url = navigationAction.request.url?.absoluteURL
            //handle your events from here
            
            if url == URL(string: "https://www.makeschool.com/dashboard#_=_") {
                let storage = WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                    for cookie in cookies {
                        if cookie.domain == "www.makeschool.com" && cookie.name == "_makeschool_session"{
                            // Setting the cookie value for the session in keychain
                            keychain.set(cookie.value, forKey: "cookieValue")
                            keychain.set(cookie.domain, forKey: "cookieDomain")
                            keychain.set(cookie.name, forKey: "cookieName")
                            HTTPCookieStorage.shared.setCookie(cookie)
                            
                        }
                    }
                    
                    
                    showFacebookUserProfile(controller: self, completionHandler: { (response) in
                        let beaconNetworkingLayer = BeaconNetworkingLayer()
                        beaconNetworkingLayer.fetchBeaconData(route: .facebookCallback(email: StaticProperties.email, firstName: StaticProperties.firstName, lastName: StaticProperties.lastName, imageUrl: StaticProperties.imageUrl), completionHandler: { (user, response) in
                            print("This is the response of the callback we made from facebook \(response)")
                            
                            let idView = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController() as! IDViewController
                            UserDefaults.standard.set(true, forKey: "LoggedIn")
                            DispatchQueue.main.async {
                                self.present(idView, animated: true, completion: nil)
                            }
                        }, requestRoute: .postReuqest)
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
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
     
    }
}

