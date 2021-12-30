//
//  AccountSettingsVc.swift
//  spotlight
//
//  Created by bajo on 2021-11-30.
//

import UIKit

class AccountSettingsVc: UIViewController {
    let tableview  = UITableView()
    
    let settingOptions = [settings(name: "Account", image: "person.crop.circle", description: "Sign out")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Account"
        
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        view.addSubview(tableview)
        tableview.register(SettingsCell.self, forCellReuseIdentifier: "settingCell")
        tableview.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100)
        tableview.delegate = self
        tableview.dataSource = self
    
    }

}

extension AccountSettingsVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(settingOptions[indexPath.row].name)
        
        
        switch indexPath.row {
        case 0:
            UserDefaults.standard.removeObject(forKey: "userkey")
            navigationController?.popViewController(animated: true)
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

