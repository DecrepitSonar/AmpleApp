////
////  RegisterViewController.swift
////  spotlight
////
////  Created by Robert Aubow on 6/25/21.
////
//
//import Foundation
//import UIKit
//
//class RegisterViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor(displayP3Red: 11 / 255, green: 11 / 255 , blue: 11 / 255, alpha: 1)
//        view.backgroundColor = .white
//        
//        let login = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(presentLoginVc))
//        login.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
//        navigationItem.rightBarButtonItem = login
//        
//        view.addSubview(Title)
//        Title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
//        Title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    
//        view.addSubview(topLoginBtn)
//        topLoginBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
//        topLoginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        
//        topLoginBtn.addTarget(self, action: #selector(presentLoginVc), for: .touchUpInside)
//        
//        // Register Button
//        view.addSubview(Register)
//        Register.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
//        Register.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        Register.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        
//        // Password reset Button
//        view.addSubview(confirmPasswordTextField)
//        confirmPasswordTextField.bottomAnchor.constraint(equalTo: Register.topAnchor, constant: -50).isActive = true
//        confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//        // Password Textfield
//        view.addSubview(PasswordTextField)
//        PasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        PasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        PasswordTextField.bottomAnchor.constraint(equalTo: confirmPasswordTextField.topAnchor, constant: -20).isActive = true
//        
//        // Username Textfield
//          view.addSubview(UsernameTextField)
//          UsernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//          UsernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//          UsernameTextField.bottomAnchor.constraint(equalTo: PasswordTextField.topAnchor, constant: -20).isActive = true
//    }
//
//    @objc func  presentLoginVc(){
//        let loginVc = LoginViewController()
//        present(loginVc, animated: true) {
//        }
//    }
//    
//    let topLoginBtn: UIButton = {
//        let btn = UIButton()
//        btn.setTitle("Login", for: .normal)
//        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    
//let Title: UILabel = {
//    let label = UILabel()
//    label.text = "Spotlight"
//    label.textColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.font = UIFont(name: "Helvetica Neue", size: 30)
//    label.font = UIFont.boldSystemFont(ofSize: 30)
//    return label
//}()
//
//let LoginBtn: LargePrimaryButton = {
//    let btn = LargePrimaryButton()
//    btn.setupButton(label: "Signup")
//    btn.backgroundColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
//    btn.setTitleColor(UIColor.black, for: .normal)
//    return btn
//}()
//
//let Register: LargePrimaryButton = {
//    let btn = LargePrimaryButton()
//    btn.setupButton(label: "Register")
//    btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
//    btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1).cgColor
//    btn.layer.borderWidth = 1
//    return btn
//}()
//
//let PasswordResetBtn: UIButton = {
//    let btn = UIButton()
//    btn.setTitle("Forgot password?", for: .normal)
//    btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
//    btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 10)
//    btn.translatesAutoresizingMaskIntoConstraints = false
//    return btn
//}()
//
//let PasswordTextField: TextFieldWithPadding = {
//    let field = TextFieldWithPadding()
//    field.translatesAutoresizingMaskIntoConstraints = false
//    field.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    field.placeholder = "Password"
////        field.layer.borderColor = UIColor.white.cgColor
//    field.textColor = UIColor.white
//    field.borderStyle = .line
//    field.attributedPlaceholder = NSAttributedString(string: "Password",
//                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.7)])
//    field.addBottomBorder()
//    return field
//}()
//
//    let UsernameTextField: TextFieldWithPadding = {
//        let field = TextFieldWithPadding()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        field.placeholder = "Username"
//    //        field.layer.borderColor = UIColor.white.cgColor
//        field.textColor = UIColor.white
//        field.borderStyle = .line
//        field.attributedPlaceholder = NSAttributedString(string: "Username",
//                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.7)])
//        field.addBottomBorder()
//        return field
//    }()
//    
//    let confirmPasswordTextField: TextFieldWithPadding = {
//        let field = TextFieldWithPadding()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        field.placeholder = "Confirm Password"
//        field.textColor = UIColor.white
//        field.borderStyle = .line
//        field.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
//                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.7)])
//        field.addBottomBorder()
//        return field
//    }()
//    
//    
//}
