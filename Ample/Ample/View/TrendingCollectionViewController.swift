//
//  TrendingCollectionViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-27.
//

import UIKit

class TrendingCollectionViewController: UIViewController {

    var tableView: UITableView!
    var data: [Track]!
    
    let loadingView = LoadingViewController()
    
    override func loadView() {
        super.loadView()
        
        addChild(loadingView)
        loadingView.didMove(toParent: self)
        view.addSubview(loadingView.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.navigationBar.prefersLargeTitles = true
        title = "Dysc Top 100"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.Get(url: "trending") { (data: [Track]?, err: NetworkError) in
            switch( err ){
            case .success:
                
                self.data = data!
                
                DispatchQueue.main.async {
                    self.loadingView.removeFromParent()
                    self.setupView()
                }
            case .notfound:
                print( "URL not found ")
            
            case .servererr:
                print( "Internal server error ")
            }
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
        tableView.register(TrackWithPlayCount.self, forCellReuseIdentifier: TrackWithPlayCount.reuseIdentifier)
        tableView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableView.separatorColor = .clear
        view.addSubview(tableView)
    }

}

extension TrendingCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackWithPlayCount.reuseIdentifier, for: indexPath) as! TrackWithPlayCount
        let item = data[indexPath.row]
        
        cell.configureWithChart(with: item, index: indexPath.row, withChart: true)
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
