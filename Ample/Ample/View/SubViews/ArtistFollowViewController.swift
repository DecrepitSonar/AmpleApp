//
//  ArtistFollowViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-04-02.
//

import UIKit

class ArtistFollowViewController: UIViewController {

    var tableView: UITableView!
    
    var data = [Artist](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let user = UserDefaults.standard.value(forKey: "user")
    
    override func loadView() {
        super.loadView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Following"
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        NetworkManager.Get(url:"user/following?user=\(user!)") { (data: [Artist]?, error: NetworkError) in
            
            switch(error){
            case .success:
                self.data = data!
                print(data!)
            case .servererr:
                print("internal server error")
            
            case .notfound:
                print("invalid resource url")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setUpTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setUpTableView(){
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LargeAviTableCell.self, forCellReuseIdentifier: LargeAviTableCell.reuseableIdentifire)
        tableView.frame = view.frame
        tableView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)

        view.addSubview(tableView)
    }

}

extension ArtistFollowViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = ProfileViewController()
        profile.id = data[indexPath.row].id
        
        navigationController?.pushViewController(profile, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LargeAviTableCell.reuseableIdentifire, for: indexPath) as? LargeAviTableCell
        
        cell!.configure(data: data[indexPath.row])
        
        return cell!
    }
    
}
