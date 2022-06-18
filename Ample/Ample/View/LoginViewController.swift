//
//  LoginViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/25/21.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

protocol LoginFormViewDelegate {
    func handleLogin()
    func didAuthoriseUser(user: UserData)
}

class LoginForm: UIStackView, LoginFormViewDelegate{
    
    var rootVc: UIViewController!
    
    let tabVc = customTab()
    
    var loginService = LoginService()
    
    var username: String?
    var password: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loginService.delegate = self
        
        addArrangedSubview(UsernameTextField)
        addArrangedSubview(PasswordTextField)
        addArrangedSubview(LoginBtn)
        addArrangedSubview(PasswordResetBtn)
        addArrangedSubview(seperator)
        addArrangedSubview(RegisterBtn)
        
        axis = .vertical
        spacing = 10
        distribution = .equalSpacing
        translatesAutoresizingMaskIntoConstraints = false
        layer.zPosition = 3

        
        NSLayoutConstraint.activate([
            PasswordResetBtn.leadingAnchor.constraint(equalTo: trailingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    required init(coder: NSCoder) {
        fatalError("")
    }
    
    @objc func handleLogin() {
        
        resignFirstResponder()
        
        print( username)
        print(password)
        guard username != nil && password != nil else{
            return
        }
        
        let formData = LoginCredentials(username: self.username!, password: self.password!)
        
        loginService.authenticateWithCredentials(credentials: formData)
        
    }
    
    func didAuthoriseUser(user: UserData) {
        
        print("did authorize user")
        
//      Inititialize new user for core data model
        UserDefaults.standard.set(user.id, forKey: "user")
        DispatchQueue.main.async {
            self.window!.rootViewController = self.tabVc
        }
        
    }
    
    let LoginBtn: UIView = {
        
        let btn = LargePrimaryButton()
        btn.setupButton(label: "Login")
        btn.backgroundColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.8)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return btn
    }()
    let RegisterBtn: LargePrimaryButton = {
        
        let btn = LargePrimaryButton()
        btn.setupButton(label: "Sign Up")
        btn.layer.borderColor =  UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
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
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1).cgColor
        
        field.addTarget(self, action: #selector(updateTextInputField(_sender:)), for: .editingChanged)
        field.isSecureTextEntry = true
        return field
    }()
    let UsernameTextField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.placeholder = "Username / Email"
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1).cgColor
        
        field.addTarget(self, action: #selector(updateTextInputField(_sender:)), for: .editingChanged)
        field.tag = 1
//
        return field
    }()
    let seperator: UIView = {
        
        let view = UIView(frame: .zero)
        view.backgroundColor = .quaternaryLabel
        
        return view
        
    }()
    
    @objc func updateTextInputField(_sender: UITextField){
            
            if( _sender.tag == 1 ) {
                username = _sender.text
                return
            }
            
            password = _sender.text
    }
}

class LoginService {
    
    var delegate: LoginFormViewDelegate!
    
    func authenticateWithCredentials(credentials: LoginCredentials){
        
        NetworkManager.Post(url: "authenticate", data: credentials) {(data: UserData?, error: NetworkError) in
            switch(error){
            case .servererr:
                print(error.localizedDescription)
            
            case .success:
                
                self.delegate.didAuthoriseUser(user: data!)
                
            case .notfound:
                print( error.localizedDescription)
            }
        }
        
    }
    
}

class LoginViewController: UIViewController {
    
    var animation: UIViewPropertyAnimator!
    let tabVc = customTab()
    let loginForm = LoginForm()
    
    override func viewWillAppear(_ animated: Bool) {
        overrideUserInterfaceStyle = .dark
        if(UserDefaults.standard.object(forKey: "userkey") == nil ){
            print("apearing")
            setupForm()
            return
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissKeyboard),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    override func viewDidLayoutSubviews() {
        viewLayer.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 130)
    }
    
    func setupForm(){
        
        view.addSubview(viewLayer)
        
        viewLayer.addSubview(bgImage)
        viewLayer.addSubview(logo)
        
        loginForm.layer.zPosition = 3
        
        viewLayer.addSubview(loginForm)
        
        NSLayoutConstraint.activate([

            bgImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            bgImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
            
            logo.topAnchor.constraint(equalTo: viewLayer.topAnchor, constant:350),
            logo.centerXAnchor.constraint(equalTo: viewLayer.centerXAnchor),

            loginForm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginForm.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 150),
            loginForm.leadingAnchor.constraint(equalTo: viewLayer.leadingAnchor, constant: 20),
            loginForm.trailingAnchor.constraint(equalTo: viewLayer.trailingAnchor, constant: -20),
            
            loginForm.widthAnchor.constraint(equalToConstant: view.frame.width),
            loginForm.heightAnchor.constraint(equalToConstant: view.frame.height / 2 - 130)
            
        ])
        
    }
    
    @objc func dismissKeyboard(){
        if viewLayer.contentOffset.y > 0 {
            viewLayer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    @objc func keyboardWillShow(sender: Notification){
        viewLayer.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
    }
   
    let viewLayer: UIScrollView = {
        
        let view = UIScrollView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: UIScreen.main.bounds.height))
//        view.backgroundColor = .red
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        return view
        
    }()
    let bgImage: UIImageView = {
        
        let bgImage = UIImageView(image: UIImage(named: "music"))
        bgImage.contentMode = .scaleAspectFill
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.alpha = 0.2
        return bgImage
        
    }()
    let logo: UILabel = {
        
        let label = UILabel()
        label.text = "Dysc"
        label.textColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
//        image.image = UIImage(named: "logo")
        return label
        
    }()
    
    
}
