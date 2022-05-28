//
//  LibraryViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-23.
//

import UIKit

class LibraryViewController: UIViewController {

    var section: [LibObject] = []
    let sections = ["Saved Songs", "History", "Saved Videos", "Saved Albums", "My Artists", "Playlists"]
    var tableview: UITableView!
    
    let user = UserDefaults.standard.value(forKey: "user")!
    let loadingView = LoadingViewController()
    
    override func loadView(){
        super.loadView()
        
        addChild(loadingView)
        loadingView.didMove(toParent: self)
        view.addSubview(loadingView.view)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Library"
        
        NetworkManager.Get(url: "library?user=\(user)") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .notfound:
                print("error url not found")
            
            case .servererr:
                print("Internal Server error")
                
            case .success:
                print(data!)
                self.section = data!
                
                DispatchQueue.main.async {
                    self.loadingView.removeFromParent()
                    self.initTableView()
                }
            }
        }
    }
    
    @objc func openSettings(){
        let view = SettingsViewController()
        navigationController?.pushViewController(view, animated: true)
    }
    func initTableView(){
        
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(ArtistFlowSectionContainer.self, forCellReuseIdentifier: ArtistFlowSectionContainer.reuseIdentifier)
        tableview.register(AlbumFlowSection.self, forCellReuseIdentifier: AlbumFlowSection.reuseIdentifier)
        tableview.register(videoCollectionFlowCell.self, forCellReuseIdentifier: videoCollectionFlowCell.reuseIdentifier)
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.frame = view.bounds
        tableview.separatorColor = .clear
        
        view.addSubview(tableview)
    }
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch( indexPath.section){
        case 0: return 140
        default: return 190
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section].tagline
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = section[indexPath.section].type
        switch(type){
                
            case "Artists":
                let cell = tableview.dequeueReusableCell(withIdentifier: ArtistFlowSectionContainer.reuseIdentifier, for: indexPath) as! ArtistFlowSectionContainer
                
                cell.configureCell(items: section[indexPath.row].items!, navigationController: self.navigationController!)
                return cell
            
            case "Video":
            
                let cell = tableview.dequeueReusableCell(withIdentifier: videoCollectionFlowCell.reuseIdentifier, for: indexPath) as! videoCollectionFlowCell
                let items = section[indexPath.section].items!

                var videos: [VideoItemModel] = []

            
                items.forEach{

                    let video = VideoItemModel(id: $0.id,
                                               videoURL: $0.videoURL!,
                                               posterURL: $0.posterURL,
                                               title: $0.title!,
                                               artist: $0.artist!,
                                               artistImageURL: nil,
                                               albumId: $0.albumId,
                                               views: 0)

                    print(video)
                    videos.append(video)

                }
                
                cell.configure(data: videos, navigationController: self.navigationController!)
            
                return cell
            
            default:
                let cell = tableview.dequeueReusableCell(withIdentifier: AlbumFlowSection.reuseIdentifier, for: indexPath) as! AlbumFlowSection
                
            cell.configure(data: section[indexPath.section].items!, navigationController: self.navigationController!)
            return cell
        }
    }
    
    
}
