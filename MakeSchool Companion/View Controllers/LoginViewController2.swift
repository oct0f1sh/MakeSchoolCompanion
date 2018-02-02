////
////  Login2.swift
////  MakeSchool Companion
////
////  Created by Duncan MacDonald on 2/2/18.
////  Copyright © 2018 Duncan MacDonald. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SnapKit
//import PMSuperButton
//
//class LoginViewController2: UIViewController { // DO NOT USE
//    
//    // MARK: - INITIALIZATION
//    
//    var logoImageView: UIImageView!
//    var nameTextField: UITextField!
//    var atLabel: UILabel!
//    var domainLabel: UILabel!
//    var loginButton: PMSuperButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.backgroundColor = Style.Colors.makeDarkBlue
//        layoutSubviews()
//        setConstraints()
//    }
//    
//    // MARK: - VIEWS
//    
//    func layoutSubviews() {
//        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 285, height: 75))
//        logoImageView.image = #imageLiteral(resourceName: "logonamewhite")
//        logoImageView.contentMode = .scaleAspectFit
//        logoImageView.clipsToBounds = true
//        
//        nameTextField = UITextField(frame: .zero)
//        nameTextField.clipsToBounds = true
//        nameTextField.placeholder = "firstname.lastname"
//        nameTextField.borderStyle = .none
//        nameTextField.textAlignment = .left
//        nameTextField.font = Style.Fonts.smallNova
//        nameTextField.textColor = Style.Colors.makeGray
//        
//        atLabel = UILabel(frame: .zero)
//        atLabel.clipsToBounds = true
//        atLabel.text = "@"
//        atLabel.font = Style.Fonts.bigNova
//        atLabel.textColor = Style.Colors.makeGray
//        
//        domainLabel = UILabel(frame: .zero)
//        domainLabel.clipsToBounds = true
//        domainLabel.text = "students.makeschool.com"
//        domainLabel.textColor = Style.Colors.makeGray
//        domainLabel.font = Style.Fonts.smallNova
//        
//        loginButton = PMSuperButton(frame: CGRect(x: 0, y: 0, width: 245, height: 55))
//        loginButton.ripple = true
//        loginButton.rippleColor = Style.Colors.makeDarkBlue
//        loginButton.backgroundColor = Style.Colors.makeLightBlue
//        loginButton.clipsToBounds = true
//        loginButton.titleLabel?.text = "LOGIN"
//        loginButton.titleLabel?.textColor = Style.Colors.makeGray
//        loginButton.titleLabel?.font = Style.Fonts.bigNova
//        
//        self.view.addSubview(logoImageView)
//        self.view.addSubview(nameTextField)
//        self.view.addSubview(atLabel)
//        self.view.addSubview(domainLabel)
//        self.view.addSubview(loginButton)
//    }
//    
//    // MARK: - CONSTRAINTS
//    
//    func setConstraints() {
//        logoImageView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(150)
//        }
//        
//        nameTextField.snp.makeConstraints { (make) in
//            make.top.equalTo(logoImageView).offset(65)
//            make.left.equalToSuperview().offset(60)
//            make.right.equalToSuperview().offset(100)
//            make.height.equalTo(30)
//        }
//        
//        atLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(nameTextField)
//            make.left.equalTo(nameTextField).offset(10)
//            make.height.equalTo(43)
//        }
//    }
//}

