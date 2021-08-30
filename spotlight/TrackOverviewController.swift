//
//  TrackOverviewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/25/21.
//

import Foundation
import UIKit

//class DetailHeader: UIView {
//    private static let identifier = "detailheader"
////    let Artists: [Artist]()
//
//    let headerContainer: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 475 ))
////        view.translatesAutoresizingMaskIntoConstraints = false
////        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
////        view.heightAnchor.constraint(equalToConstant: 475).isActive = true
////        view.layer.borderWidth = 1
////        view.backgroundColor = .red
//        return view
//    }()
//
//    let detailImage: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "mac")
//        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 12
//        view.contentMode = .scaleAspectFit
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let artistLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Mac Ayres"
//        label.font = UIFont.boldSystemFont(ofSize: 10)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let trackLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Drive slow"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Helvetica Neue", size: 20)
//        return label
//    }()
//
//    func configure(album: Album){
//        self.addSubview(headerContainer)
//////
////        let currentTrack = LargeAlbumCover(frame: CGRect(x: 60, y: 10, width: 275, height: 275))
//        currentTrack.SetupAlbumCover(album: album)
//
//
//        headerContainer.addSubview(currentTrack)
////        currentTrack.topAnchor.constraint(equalTo: headerContainer.centerXAnchor).isActive = true
//
//        headerContainer.addSubview(detailImage)
//        detailImage.topAnchor.constraint(equalTo: currentTrack.bottomAnchor, constant:  20).isActive = true
//        detailImage.leadingAnchor.constraint(equalTo: currentTrack.leadingAnchor).isActive = true
//
//        headerContainer.addSubview(artistLabel)
//        artistLabel.leadingAnchor.constraint(equalTo: detailImage.trailingAnchor, constant: 10).isActive = true
//        artistLabel.topAnchor.constraint(equalTo: detailImage.topAnchor).isActive = true
//
//        headerContainer.addSubview(trackLabel)
//        trackLabel.leadingAnchor.constraint(equalTo: detailImage.trailingAnchor, constant: 10).isActive = true
//        trackLabel.bottomAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20).isActive = true
//    }
//}



class TrackOverviewController: UIViewController {
    var albumid = String()
    let header = HeaderDetail()
    let footer = DetailFooterDetail()
    
    var currentAlbum: Album? {
        didSet{
            header.config(album: currentAlbum!)
        }
    }
        
    var Songs = [Song](){
        didSet{
            tableview.reloadData()
        }
    }
    
    var tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.3)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = currentAlbum?.Artist
        
        
        
        view.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(Track.self, forCellReuseIdentifier: "track")
//        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableview.register(DetailFooterDetail.self, forCellReuseIdentifier: "footer")

        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        tableview.tableHeaderView?.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        tableview.backgroundColor = .systemBackground
        tableview.tableHeaderView = header
    }
    
    func getAlbumDetail(albumId: String){
        NetworkManager.getAlbum(id: albumId) { (result) in
            switch(result){
            case .success(let album):
                self.currentAlbum = album
                print(album)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getTracks(albumId: String){
        NetworkManager.getTracks(albumId: albumId) { (result) in
            switch(result){
            case .success(let tracks ):
                self.Songs = tracks
                print(tracks)
            case .failure(let err):
                print(err)
            }
        }
    }
    func getSingleTrack(trackId: String){
        NetworkManager.getTrack(trackId: trackId) { (result) in
            switch(result){
            case .success(let song):
                self.Songs.append(song)
                print(song)
            case .failure(let err):
                print(err)
            }
        }
    }
        
    override func viewDidLayoutSubviews() {
        tableview.frame = view.bounds
//        moreMusicScrollContainer.contentSize = CGSize(width: 1600, height: 0)
//        relatedArtistSV.contentSize = CGSize(width: 950, height: 0)
    }
    
}

extension TrackOverviewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Songs.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? Track
//        cell.textLabel?.text = " \(indexPath.row + 1)    \(Songs[indexPath.row].Title)"
        cell?.configure(indexPath: indexPath.row, image: currentAlbum!.Artist ?? "", trackName: Songs[indexPath.row].Title ?? "")
//        cell.textLabel?.textColor = .white
        return cell!
    }
}
