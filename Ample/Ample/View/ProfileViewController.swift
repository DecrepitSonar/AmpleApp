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
    
    let loadingView = LoadingViewController()

    override func viewWillAppear(_ animated: Bool) {}
    override func viewWillDisappear(_ animated: Bool) {}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        let infoBtn = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"), style: .plain , target: nil, action: nil)
        infoBtn.tintColor = .gray
        navigationItem.rightBarButtonItem = infoBtn
        
        let backbutton = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(didTapBackButton))
        backbutton.tintColor = .gray
        navigationItem.leftBarButtonItem = backbutton
        
        header = ProfileHead(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
        
        NetworkManager.Get(url: "artist?id=\(artistId!)") { (data: ProfileObject?, error: NetworkError ) in
            switch( error){
            case .success:
                
                self.data = data!
                
                DispatchQueue.main.async {
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
      
        tableview = UITableView()
        tableview.frame = view.frame
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.contentInsetAdjustmentBehavior = .never

        tableview.separatorColor = UIColor.clear
        tableview.bounces = false
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        tableview.register(TrackWithPlayCount.self, forCellReuseIdentifier: TrackWithPlayCount.reuseIdentifier)
        tableview.register(AlbumFlowSection.self, forCellReuseIdentifier: AlbumFlowSection.reuseIdentifier)
        tableview.register(videoCollectionFlowCell.self, forCellReuseIdentifier: videoCollectionFlowCell.reuseIdentifier)
        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableview.backgroundColor = .black
        initHeader()
        tableview.tableHeaderView = header
        
        view.addSubview(tableview)
    }
    
    func initHeader(){
        
        header.image.setUpImage(url: data.imageURL, interactable: false)
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
        
    }
    
    @objc func didTapBackButton(_sender: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return data.items[section].items!.count
        } else {return 1}
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.items.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TableSectionHeader()
        header.label.text = data.items[section].tagline
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = data.items[indexPath.section].type
        
        switch (type) {
        case "Tracks":
            
            let item = data.items[indexPath.section].items![indexPath.row]
            
            let track = Track(id: item.id,
                              type: item.type,
                              trackNum: nil,
                              title: item.title!,
                              artistId: item.artistId!,
                              name: item.name!,
                              imageURL: item.imageURL!,
                              albumId: item.albumId!,
                              audioURL: item.audioURL,
                              playCount: Int(item.playCount!),
                              videoId: nil)
            
            let cell = tableview.dequeueReusableCell(withIdentifier: TrackWithPlayCount.reuseIdentifier, for: indexPath) as! TrackWithPlayCount
            cell.configureWithChart(with: track, index: nil, withChart: false)
            cell.selectionStyle = .none
            return cell
            
        case "Videos":
        
            
            let indexedItem = data.items[indexPath.section].items!
            
            var videos: [VideoItemModel] = []
            
            indexedItem.forEach { item in
                
                let video = VideoItemModel(id: item.id,
                                           videoURL: item.videoURL!,
                                           posterURL: item.posterURL,
                                           title: item.title!,
                                           artist: item.artist!,
                                           artistImageURL: nil,
                                           albumId: nil,
                                           views: 0)
                videos.append(video)
            }
            
            let cell = tableview.dequeueReusableCell(withIdentifier: videoCollectionFlowCell.reuseIdentifier, for: indexPath) as! videoCollectionFlowCell
            cell.configure(data: videos, navigationController: self.navigationController!)
            cell.selectionStyle = .none
        
            return cell
            
        default:
            let cell = tableview.dequeueReusableCell(withIdentifier: AlbumFlowSection.reuseIdentifier, for: indexPath) as! AlbumFlowSection
            cell.configure(data: data.items[indexPath.section].items!, navigationController: self.navigationController!)
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data.items[indexPath.section].items![indexPath.row]
        
        let track = Track(id: item.id,
                          type: item.type,
                          trackNum: nil,
                          title: item.title!,
                          artistId: item.artistId!,
                          name: item.name!,
                          imageURL: item.imageURL!,
                          albumId: item.albumId!,
                          audioURL: item.audioURL,
                          playCount: Int(item.playCount!))
        
        AudioManager.shared.initPlayer(track: track, tracks: nil)
    }
}
