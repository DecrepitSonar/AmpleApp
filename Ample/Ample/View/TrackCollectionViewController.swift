//
//  TrendingCollectionViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-27.
//

import UIKit

enum collectionType {
    case History
    case Tracks
}
class TrackCollectionViewController: UIViewController {

    var tableView: UITableView!
    var data: [Track]!
    let user = UserDefaults.standard.value(forKey: "user")
    let loadingView = LoadingViewController()
    var type: collectionType!
    
    override func loadView() {
        super.loadView()
        
        addChild(loadingView)
        loadingView.didMove(toParent: self)
        view.addSubview(loadingView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.navigationBar.prefersLargeTitles = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch(type){
        case .Tracks:
            
            title = "Saved"
            NetworkManager.Get(url: "user/savedTracks?user=\(user!)") { (data: [Track]?, result: NetworkError) in
                switch(result){
                case .success:
                    print( data!)
                    self.data = data!
                    
                    DispatchQueue.main.async {
                        self.setupView()
                    }
                    
                case .notfound:
                    print( "url not found")
                case .servererr:
                    print("internal server error")
                }
            }
            
        case .History:
            
            title = "History"
            NetworkManager.Get(url: "user/history?type=track&&user=\(user!)") { (data: [Track]?, result: NetworkError) in
                switch(result){
                case .success:
                    print( data!)
                    self.data = data!
                    
                    DispatchQueue.main.async {
                        self.setupView()
                    }
                    
                case .notfound:
                    print( "url not found")
                case .servererr:
                    print("internal server error")
                }
            }
            
        default: return
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupView(){
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        tableView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableView.separatorColor = .clear
        view.addSubview(tableView)
    }

}

extension TrackCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackStrip.reuseIdentifier, for: indexPath) as! TrackStrip
        let item = data[indexPath.row]
        
        cell.configure(track: item)
        cell.backgroundColor = .clear
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioManager.shared.initPlayer(track: data[indexPath.row], tracks: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
}
