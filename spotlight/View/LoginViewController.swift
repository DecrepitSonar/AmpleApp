//
//  LoginViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/25/21.
//

import Foundation
import UIKit
import AVFoundation


class LoginForm: UIStackView{
    
    var rootVc: UIViewController!
    
    let tabVc = customTab()
    
    var username: String?
    var password: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    let LoginBtn: UIView = {
        
        let btn = LargePrimaryButton()
        btn.setupButton(label: "Login")
        btn.backgroundColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.8)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        return btn
    }()
    
    let RegisterBtn: LargePrimaryButton = {
        
        let btn = LargePrimaryButton()
        btn.setupButton(label: "Sign Up")
//        btn.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        btn.layer.borderWidth = 1
        btn.layer.borderColor =  UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
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
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1).cgColor
        
        field.addTarget(self, action: #selector(updatePasswordTxtField), for: .editingChanged)
        field.isSecureTextEntry = true
        
        field.addTarget(self, action: #selector(openKeyboard(sender:)), for: .editingChanged)
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
        
        field.addTarget(self, action: #selector(updateUsernameTxtField), for: .editingChanged)
//        field.addTarget(self, action: #selector(openKeyboard(sender:)), for: .editingDidBegin)
//
        return field
    }()
    
    let seperator: UIView = {
        
        let view = UIView(frame: .zero)
        view.backgroundColor = .quaternaryLabel
        
        return view
        
    }()
    
    @objc func signIn(){
        
        guard username != nil && password != nil else{
            return
        }
        
        print("loggin gin")
        let formData = LoginCredentials(username: self.username!, password: self.password!)
//        print(formData)
        
        NotificationCenter.default.post(name: Notification.Name("isLoggedIn"), object: nil, userInfo: ["credentials" : formData as? LoginCredentials])
    }
    
    @objc func updateUsernameTxtField(_sender: UITextField){
        
        print(_sender.text as? String)
        username = _sender.text
        
    }
    
    @objc func updatePasswordTxtField(_sender: UITextField){
        print(_sender.text as? String)
        password = _sender.text
//        print(password!)
    }
    
    @objc func openKeyboard(sender: UITextField){
        sender.becomeFirstResponder()
    }
}


class LoginViewController: UIViewController {
    
    
    let tabVc = customTab()
    var animation: UIViewPropertyAnimator!
    
    let loginForm = LoginForm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogin), name: NSNotification.Name("isLoggedIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func dismissKeyboard(){
        if viewLayer.contentOffset.y > 0 {
            viewLayer.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
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

    @objc func handleLogin(sender: Notification){
        
        let alert = UIAlertController()
        let alertOkAction = UIAlertAction(title: "OK", style: .cancel) { alert in
            self.dismiss(animated: true)
        }
    
        alert.addAction(alertOkAction)
        if let sender = sender.userInfo as NSDictionary?{
            if let formData = sender.object(forKey: "credentials") as? LoginCredentials{
             
                guard formData.username != nil && formData.password != nil else {
                   return
                }
                
    
            let credentials = LoginCredentials(username: formData.username, password: formData.password)
//
            NetworkManager.Post(url: "authenticate", data: credentials) {(data: UserData, error: NetworkError) in
                switch(error){
                case .servererr:
                    print(error.localizedDescription)
                
                case .success:
                    UserDefaults.standard.set(data.id, forKey: "userdata")
                
                    DispatchQueue.main.async {
                        self.present(self.tabVc, animated: true)
                    }
                case .notfound:
                    print( error.localizedDescription)
                }
            }
                
            }
        }

    }

    @objc func keyboardWillShow(sender: Notification){
        print("keyboard shown")
        viewLayer.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if(UserDefaults.standard.object(forKey: "userkey") != nil ){
            print("apearing")
            return
        }
        
        setupForm()

    }
    
    override func viewDidLayoutSubviews() {
        viewLayer.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 130)
    }
    
    override func viewWillLayoutSubviews() {
        
        let tabVc = customTab()
        
        if(UserDefaults.standard.object(forKey: "userdata") != nil ){
            present(tabVc, animated: true)
        }
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
        label.text = "PlayBase"
        label.textColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 30)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
        
    }()
    
    
}
