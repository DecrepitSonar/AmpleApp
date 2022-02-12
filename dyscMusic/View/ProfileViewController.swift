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
    var header: ProfileHead!
    
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
        header = ProfileHead(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350))

        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        NetworkManager.Get(url: "artist?id=\(artistId!)") { (data: ProfileObject?, error: NetworkError ) in
            switch( error){
            case .success:
                
                self.data = data!
                
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
        tableview.bounces = false
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight  = 100
        
        tableview.register(ProfileContentSection.self, forCellReuseIdentifier: ProfileContentSection.reuseIdentifier)
        initHeader()
        view.addSubview(tableview)
    }
    
    func initHeader(){
        
        header.image.setUpImage(url: data.imageURL)
        header.name.text = data.name
        let artist = Artist(id: data.artistId,
                               type: data.type,
                               name: data.name,
                               imageURL: data.imageURL,
                               isVerified: data.isVerified,
                               joinDate: data.joinDate,
                               subscribers: data.subscribers
        )
        
        let subscribers = NumberFormatter.localizedString(from: NSNumber(value: data.subscribers), number: NumberFormatter.Style.decimal)
        
        header.subscribersLabel.text = " \(data.type) • Subscribers: \(subscribers)"
        header.setupHeader(artist: artist)
        tableview.tableHeaderView = header
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = tableview.contentOffset.y
        
        print(offset)
        
        if(offset < 350 ){
            header.image.center.y =  header.center.y + offset
            return
        }

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
