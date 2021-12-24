//
//  SettingsViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/27/21.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let identifier = "settingCell"
    
    let container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        return view
    }()
    
    let settingImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.setFont(with: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let settingsDescription: UILabel = {
        let label = UILabel()
        label.setFont(with: 10)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with image: String, settinglabel: String, description: String){
        
        settingsLabel.text = settinglabel
        settingsDescription.text = description
        settingImage.image = UIImage(systemName: image)
        settingImage.contentMode = .scaleAspectFit
        
        let labelStack = UIStackView(arrangedSubviews: [settingsLabel, settingsDescription])
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing

        print(settinglabel)

        let containerStack = UIStackView(arrangedSubviews: [settingImage, labelStack])
        containerStack.axis = .horizontal
        containerStack.distribution = .equalSpacing
        containerStack.spacing = 20
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(container)
        container.addSubview(containerStack)
        
        NSLayoutConstraint.activate( [
            
            settingImage.widthAnchor.constraint(equalToConstant: 30),
            containerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            containerStack.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
    }
    
}

class SettingsViewController: UIViewController {
    let tableview  = UITableView()
    
    let settingOptions = [settings(name: "Account", image: "person.crop.circle", description: "Username and account information"),
                          settings(name: "Privacy", image: "terminal.fill", description: "Controll how your information is processed"),
                          settings(name: "Security", image: "lock.shield", description: "set up authentication methods like two step authentication"),
                          settings(name: "Wallet", image: "creditcard", description: "Payment method and accumulated charges"),
                          settings(name: "Notifications", image: "bell", description: "Set how your notified when stuff happens"),
                          settings(name: "About", image: "questionmark.circle", description: "Learn about application features and other information")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
        
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        view.addSubview(tableview)
        tableview.register(SettingsCell.self, forCellReuseIdentifier: "settingCell")
        tableview.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100)
        tableview.delegate = self
        tableview.dataSource = self
    
    }

    let logoutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: .normal)
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(settingOptions[indexPath.row].name)
        
        let account = AccountSettingsVc()
        let privacy = PrivacySettingsVc()
        let security = SecuritySettingsVc()
        let wallet = WalletSettingsVc()
        let notifications = NotificationSettingsVc()
        let about = aboutVc()
        
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(account, animated: true)
        case 1:
            navigationController?.pushViewController(privacy, animated: true)
        case 2:
            navigationController?.pushViewController(security, animated: true)
        case 3:
            navigationController?.pushViewController(wallet, animated: true)
        case 4:
            navigationController?.pushViewController(notifications, animated: true)
        case 5:
            navigationController?.pushViewController(about, animated: true)
        default: return
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsCell
        cell.configure(with: settingOptions[indexPath.row].image,
                       settinglabel: settingOptions[indexPath.row].name,
                       description: settingOptions[indexPath.row].description)
        
        return cell
    }
    
    
}
