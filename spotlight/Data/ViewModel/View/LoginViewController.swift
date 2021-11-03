//
//  LoginViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/25/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        view.backgroundColor = .systemBackground
        
//        let helpBtn = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(cancel))
//        helpBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
//        navigationItem.rightBarButtonItem = helpBtn
        
//
        view.addSubview(Title)
        Title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        Title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        // Register Button
//        let keyboardDismissGesture =  UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // Login Button
        view.addSubview(LoginBtn)
        LoginBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        LoginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        LoginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        LoginBtn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        // Password reset Button
        view.addSubview(PasswordResetBtn)
        PasswordResetBtn.bottomAnchor.constraint(equalTo: LoginBtn.topAnchor, constant: -50).isActive = true
        PasswordResetBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        PasswordResetBtn.addGestureRecognizer(keyboardDismissGesture)
        
//        // Password Textfield
        view.addSubview(PasswordTextField)
        PasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        PasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        PasswordTextField.bottomAnchor.constraint(equalTo: PasswordResetBtn.topAnchor, constant: -20).isActive = true
//        PasswordResetBtn.addGestureRecognizer(keyboardDismissGesture)
        
        // Username Textfield
        view.addSubview(UsernameTextField)
        UsernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        UsernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        UsernameTextField.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: -20).isActive = true
//        UsernameTextField.addGestureRecognizer(keyboardDismissGesture)
        
        
    }
    
    
    @objc func handleLogin(){
        
        let tabVc = customTab()
        
//        tabVc.modalPresentationStyle = .fullScreen
//        tabVc.modalTransitionStyle = .crossDissolve
        present(tabVc, animated: true)
    }
    
    
    
    let Title: UILabel = {
        let label = UILabel()
        label.text = "Spotlight"
        label.textColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let LoginBtn: LargePrimaryButton = {
        let btn = LargePrimaryButton()
        btn.setupButton(label: "Login")
        btn.backgroundColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    let PasswordResetBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Forgot password?", for: .normal)
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 10)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let PasswordTextField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.placeholder = "Password"
//        field.layer.borderColor = UIColor.white.cgColor
//        field.textColor = UIColor.white
//        field.borderStyle = .line
        field.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.7)])
        field.addBottomBorder()
        return field
    }()
    
    let UsernameTextField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.placeholder = "Username"
//        field.layer.borderColor = UIColor.white.cgColor
//        field.textColor = UIColor.white
        field.borderStyle = .line
        field.attributedPlaceholder = NSAttributedString(string: "Username",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.7)])
        field.addBottomBorder()
        return field
    }()
}

