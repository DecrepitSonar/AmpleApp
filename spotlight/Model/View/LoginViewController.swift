//
//  LoginViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/25/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let tabVc = customTab()
    
    var username: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        
    }
    override func viewWillLayoutSubviews() {
        
        if(UserDefaults.standard.object(forKey: "userkey") != nil ){
            print("apearing")
            present(tabVc, animated: true)
        }
        else{
            setupLoginView()
        }
    }

    
    func setupLoginView(){
        view.addSubview(Title)
        
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .quaternaryLabel
        
        let loginStack = UIStackView(arrangedSubviews: [UsernameTextField, PasswordTextField, LoginBtn, PasswordResetBtn, seperator, RegisterBtn])
        loginStack.axis = .vertical
        loginStack.spacing = 15
        loginStack.distribution = .equalSpacing
        loginStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginStack)
        
        NSLayoutConstraint.activate([

            Title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            Title.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            PasswordResetBtn.leadingAnchor.constraint(equalTo: loginStack.trailingAnchor),

            seperator.heightAnchor.constraint(equalToConstant: 1),

            loginStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40 ),
            loginStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    
    @objc func handleLogin(){
        
        guard username != nil && password != nil else {
            return
        }
        
        let credentials = credentials(username: username!, password: password!)
        
        NetworkManager.authenticateUser(user: credentials) { result in
            switch( result){
            case .success(let data):
                UserDefaults.standard.set(data.apiKey , forKey: "userkey")
                UserDefaults.standard.set(data.username, forKey: "username")
              
                DispatchQueue.main.async {
                    self.present(self.tabVc, animated: true)
                }
                  
                print("success")
                      
            case .failure(let err):
                print("fail")
            }
        }

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
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    let RegisterBtn: LargePrimaryButton = {
        let btn = LargePrimaryButton()
        btn.setupButton(label: "Sign Up")
        btn.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        btn.layer.borderWidth = 1
        btn.layer.borderColor =  UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1).cgColor
//        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
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
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        field.addTarget(self, action: #selector(updatePasswordTxtField), for: .editingChanged)
        
        return field
    }()
    
    let UsernameTextField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.placeholder = "Username / Email"
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        
        field.addTarget(self, action: #selector(updateUsernameTxtField), for: .editingChanged)
//        field.addBottomBorder()
        return field
    }()
    
    @objc func updateUsernameTxtField(_sender: UITextField){
//        print(_sender.text as? String)
        username = _sender.text
    }
    
    @objc func updatePasswordTxtField(_sender: UITextField){
//        print(_sender.text as? String)
        password = _sender.text
//        print(password!)
    }
    
    
}

