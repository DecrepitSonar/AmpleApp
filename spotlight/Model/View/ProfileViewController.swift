//
//  ProfileViewController.swift
//  spotlight
//
//  Created by bajo on 2022-01-24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var artistId: String?
    var data: ProfileObject!
    
    var tableview: UITableView!
    
    let loadingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .red
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(loadingView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        NetworkManager.Get(url: "artist?id=\(artistId!)") { (data: ProfileObject, error: NetworkError ) in
            switch( error){
            case .success:
                
                self.data = data
                
                DispatchQueue.main.async {
                    self.loadingView.removeFromSuperview()
                    self.initTable()
                }
                
            case .servererr:
                print(error.localizedDescription)
            case .notfound:
                print(error.localizedDescription)
                
            }
        }
    }
    
    func initTable(){
      
        tableview = UITableView(frame: view.frame, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.backgroundColor = .orange
        tableview.contentInsetAdjustmentBehavior = .never
        tableview.backgroundColor = .clear
        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableview.register(ProfileContentSection.self, forCellReuseIdentifier: ProfileContentSection.reuseIdentifier)
        initHeader()
        view.addSubview(tableview)
    }
    
    func initHeader(){
        let header = ProfileHead(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350))
        header.image.setUpImage(url: data.imageURL)
        header.name.text = data.name
        
        let subscribers = NumberFormatter.localizedString(from: NSNumber(value: data.subscribers), number: NumberFormatter.Style.decimal)
        
        header.subscribersLabel.text = " \(data.type) • Subscribers: \(subscribers)"
        let user = UserDefaults.standard.object(forKey: "userdata")
        
        NetworkManager.Get(url: "user?id=\(data.id)&&user=\(user!)") { ( result: Artist, error: NetworkError ) in
            switch(error){
            case .notfound:
                print("404")
            
            case .servererr:
                print("server error")
            
            case .success:
                print("result")
                print(result)
            }
        }
        tableview.tableHeaderView = header
        
    }
    
    func didTapFollowBtn(){
//        NetworkManager.updateFollowStatus(id: artistId){ result in
//
//        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: ProfileContentSection.reuseIdentifier, for: indexPath) as! ProfileContentSection
        cell.navigationController = navigationController
        cell.section = data.items
        return cell
    }
    
    
}
