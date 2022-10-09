//
//  TrackHistoryViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/27/21.
//

import UIKit

class TrackHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tracks = [Track](){
        didSet{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    var tableview: UITableView!
    var user = UserDefaults.standard.value(forKey: "user")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        title = "History"
        
        NetworkManager.Get(url: "history/user/\(user)/?type=track", completion: { (data: [Track]!, err: NetworkError) in
            switch(err){
                case .notfound:
                    print( "404 not found")
                
                case .servererr:
                    print( "Internal server error")
                    
                case .success:
                    self.tracks = data!
                self.setupTableView()
                
            }
        })
    
    }

    override func viewDidLayoutSubviews() {
        
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.frame = view.bounds
        
        tableview.register(TrackStrip.self, forCellReuseIdentifier: "trackcell")
        
        view.addSubview(tableview)
        
    }
    
    func setupTableView(){
        
    }
    let sectionHeader: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .red
        return view
    }()
}

//TrackTablvi
extension TrackHistoryViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = tracks[indexPath.row].name

        let cell = tableview.dequeueReusableCell(withIdentifier: "trackcell", for: indexPath) as! TrackStrip
        cell.configure(track: tracks[indexPath.row])
//        cell.configure(with: tracks[indexPath.row].Artists ?? "", trackname: tracks[indexPath.row].Title ?? "", img: tracks[indexPath.row].Image ?? "")

        return cell
    }
}
