//
//  SettingsViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/27/21.
//

import UIKit

struct settings{
    let name: String
    let image: String
}

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
        label.setFont(with: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with image: String, settinglabel: String){
        contentView.addSubview(container)
        container.addSubview(settingImage)
        settingImage.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        settingImage.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        settingImage.image = UIImage(systemName: image)
        
        container.addSubview(settingsLabel)
        settingsLabel.leadingAnchor.constraint(equalTo: settingImage.leadingAnchor, constant: 35).isActive = true
        settingsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        settingsLabel.text = settinglabel
    }
    
}

class SettingsViewController: UIViewController {
    let tableview  = UITableView()
    
    let settingOptions = [settings(name: "Account", image: "person.fill.viewfinder"), settings(name: "Notifications", image: "bolt"), settings(name: "Privacy", image: "terminal.fill"), settings(name: "Security", image: "lock.shield"), settings(name: "Payment", image: "creditcard"), settings(name: "About", image: "questionmark.circle")]
    
    
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

        view.addSubview(logoutBtn)
        logoutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        logoutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        logoutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsCell
//        cell.textLabel?.text = settingOptions[indexPath.row]
//        cell.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        cell.configure(with: settingOptions[indexPath.row].image, settinglabel: settingOptions[indexPath.row].name)
        return cell
    }
    
    
}
