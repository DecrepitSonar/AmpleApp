//
//  DetailViewController.swift
//  spotlight
//
//  Created by bajo on 2022-01-23.
//

import UIKit
import CoreAudio

enum SectionType{
    case Tracks
    case video
}

struct Album: Codable {
    var id: String
    var type: String?
    var title: String?
    var artistId: String?
    var artist: String?
    var name: String?
    var imageURL: String
    var albumId: String?
    var joinDate: String?
    var artistImgURL: String?
    var items: [AlbumSection]?
}

struct AlbumSection: Codable {
    var id: String
    var type: String
    var tagline: String
    var items: [AlbumItems]
}
struct AlbumItems: Codable {
    var id: String
    var type: String?
    var trackNum: UInt?
    var title: String
    var artist: String?
    var artistId: String?
    var name: String?
    var imageURL: String?
    var albumId: String?
    var audioURL: String?
    var playCount: Int?
    var videoURL: String?
    var posterURL: String?
//    var views: int?
}
class AlbumViewController: UIViewController {

    var albumId = String()
    var data: Album?
    var tableView: UITableView!
    let user = UserDefaults.standard.value(forKey: "user")
    var header: DetailHeader!
    
    let loadingView = LoadingViewController()
//    override func loadView(){
//        super.loadView()
//
//        addChild(loadingView)
//        loadingView.didMove(toParent: self)
//        view.addSubview(loadingView.view)
//
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named: "chevron.left"), style: .plain, target: self, action: nil)
        
        NetworkManager.Get(url: "album?albumId=\(albumId)") { (data: Album?, error: NetworkError) in
            switch(error){
            case .servererr:
                print(error.localizedDescription)
            
            case .success:
                
                self.data = data!
                
                DispatchQueue.main.async {
//                    self.loadingView.removeFromParent()
                    self.setup()
                }
                
            case .notfound:
                print(error.localizedDescription)
            }
        }
    }
    
    func setup(){
    
        header = DetailHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 550))
        header.artist.text = data?.name
        header.albumImage.setUpImage(url: data!.imageURL, interactable: false)
        header.imageContainer.setUpImage(url: data!.imageURL, interactable: false)
        header.trackTitle.text = data?.title
        header.artistAviImage.setUpImage(url: data!.artistImgURL!, interactable: true)
        header.vc = navigationController
        header.artistId = data!.artistId!
        header.type = data!.type
        
        let trackItems = data?.items![0].items
        var tracks: [Track] = []
        
        trackItems!.forEach { item in
            
//            print(item),
            
            let track = Track(id: item.id,
                              type: item.type!,
                              trackNum: item.trackNum!,
                              title: item.title,
                              artistId: item.artistId!,
                              name: item.name!,
                              imageURL: item.imageURL!,
                              albumId: item.albumId!,
                              audioURL: item.audioURL,
                              playCount: item.playCount,
                              videoId: item.videoURL)
            
            tracks.append(track)
        }
        
        header.tracks
//        header.checkIfAlbumIsSaved()

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        tableView.register(AlbumFlowSection.self, forCellReuseIdentifier: AlbumFlowSection.reuseIdentifier)
        tableView.register(videoCollectionFlowCell.self, forCellReuseIdentifier: videoCollectionFlowCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounds = view.bounds
        tableView.bounces = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.frame = view.bounds
//        tableView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        self.tableView.tableHeaderView = header
        view.addSubview(tableView)
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data!.items!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch( section){
            case 0: return data!.items![section].items.count
            default: return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(data?.items![indexPath.section].type){
            case "Tracks": return 50
            case "Videos": return 150
            default: return 210
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            let selectedItem = data!.items![indexPath.section].items[indexPath.row]
            
            let track = Track(id: selectedItem.id,
                              type: selectedItem.type,
                              trackNum: nil,
                              title: selectedItem.title,
                              artistId: selectedItem.artistId!,
                              name: selectedItem.name!,
                              imageURL: selectedItem.imageURL!,
                              albumId: selectedItem.albumId!,
                              audioURL: selectedItem.audioURL!,
                              playCount: nil,
                              videoId: nil)
            
            AudioManager.shared.initPlayer(track:  track, tracks: nil)
            
            tableView.cellForRow(at: indexPath)?.tintColor = .red
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data!.items![section].tagline
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = (data?.items![indexPath.section].type)
        
        
        switch(type){
        case "Tracks":
                
                let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as! TrackCell
                
                let item = data!.items![indexPath.section].items[indexPath.row]
            
                let track = Track(id: item.id,
                                  type: item.type,
                                  trackNum: item.trackNum,
                                  title: item.title,
                                  artistId: item.artistId!,
                                  name: item.name!,
                                  imageURL: item.imageURL!,
                                  albumId: item.albumId!,
                                  audioURL: item.audioURL,
                                  playCount: nil,
                                  videoId: nil)
            
                cell.configure(with: track)
                cell.backgroundColor = .clear
                
                return cell
        
        case "Videos":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: videoCollectionFlowCell.reuseIdentifier, for: indexPath) as! videoCollectionFlowCell
            let items = data!.items![indexPath.section].items

            var videos: [VideoItemModel] = []

            items.forEach{

                let video = VideoItemModel(id: $0.id,
                                           videoURL: $0.videoURL!,
                                           posterURL: $0.posterURL,
                                           title: $0.title,
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumFlowSection.reuseIdentifier, for: indexPath) as! AlbumFlowSection
            let items = data!.items![indexPath.section].items

            var albums: [LibItem] = []

            items.forEach{

                let album = LibItem(id: $0.id,
                                    trackNum: nil,
                                    genre: nil,
                                    type: nil,
                                    title: $0.title,
                                    artistId: nil,
                                    posterImage: nil,
                                    artist: $0.artist,
                                    name: $0.name,
                                    imageURL: $0.imageURL!,
                                    audioURL: nil,
                                    albumId: nil,
                                    playCount: nil,
                                    subscribers: nil,
                                    isVerified: nil,
                                    joinDate: nil)

                albums.append(album)

            }
            
            cell.configure(data: albums, navigationController: self.navigationController!)
        
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        if(indexPath.section == 0 ){
            
            let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
//                print(self.data!.tracks[indexPath.row])
                
                NetworkManager.Delete(url: "user/savedTracks?user=\(self.user!)") { (error : NetworkError) in
                    switch(error){
                    case .notfound:
                        print("url not found")
                   
                    case .servererr:
                        print("Internal server error")
                        
                    case .success:
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [indexPath], with: .left)
                        }
                        print("success")
                    }
                }
           
            }
            
            let saveAction = UIContextualAction(style: .normal, title: "") { action, view, Completion in
                NetworkManager.Post(url: "user/savedTracks?user=\(self.user!)", data: self.data!.items![indexPath.section].items[indexPath.row]) { (data: Album?, err: NetworkError) in
                    
                    switch(err){
                    case .notfound:
                        print("url not found ")
                        
                    case .servererr:
                        print( "internal server error")
                    
                    case .success:
                        print("success")
                    }
                }
            }
            
            return UISwipeActionsConfiguration(actions: [saveAction])
        }
        return nil
         
    }
}

