//
//  HomeViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/29/21.
//

import UIKit

//class RVC: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//    }
//}

class HomeViewController: UIViewController, UISearchResultsUpdating {
    
    let tableview = UITableView()
    let primaryScrollContainer = UIScrollView()
    let searchController = UISearchController(searchResultsController: RVC())

    let featured  = FeaturedAlbums()
//    let featuredArtists = FeaturedArtists()
    let trackHistory = TrackHistory()
    let albumSlider = AlbumSlider()
    let playlists = PlaylistSlider()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
            
        let settingsBtn = UIImage(systemName: "gear")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsBtn, style: .plain, target: self, action: #selector(presentSettings))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        
        title = "Home"

        view.addSubview(primaryScrollContainer)
    
        primaryScrollContainer.showsVerticalScrollIndicator = false
        let searchController = UISearchController(searchResultsController: RVC())
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        setupHeader()
//        setupArtistSection()
        setupTrackHistory()
        setupDiscovery()
        setupPlaylist()
//        setupGenre()
    }
    override func viewDidLayoutSubviews() {
        primaryScrollContainer.frame = view.bounds
        primaryScrollContainer.contentSize = CGSize(width: 0, height: 1600)
    }
    
    @objc func presentSettings(){
        let settings = SettingsViewController()
        navigationController?.pushViewController(settings, animated: true)
    }
    
    func setupHeader(){
        
        let label = Label()
        label.configure(text: "In The Spotlight", withNavButton: false, view: self.navigationController)
        
        primaryScrollContainer.addSubview(label)
        label.topAnchor.constraint(equalTo: primaryScrollContainer.topAnchor, constant:  20).isActive = true
        
        primaryScrollContainer.addSubview(featured)
        featured.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        featured.setRootVc(vc: navigationController!)
    }
//    func setupArtistSection(){
//
//        // set up label
//        let label = Label()
//        label.configure(text: "\"Up Next\" Artists", withNavButton: false, view: self.navigationController)
//        primaryScrollContainer.addSubview(label)
//
//        label.topAnchor.constraint(equalTo: featured.bottomAnchor, constant: 20).isActive = true
//
//        // add artists component
//        primaryScrollContainer.addSubview(featuredArtists)
//        featuredArtists.setRootVc(vc: self.navigationController!)
//        featuredArtists.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
//        featuredArtists.leadingAnchor.constraint(equalTo: primaryScrollContainer.leadingAnchor).isActive = true
//    }
    func setupTrackHistory(){
        let label = Label()
        label.configure(text: "History", withNavButton: true, view: self.navigationController)
        
        primaryScrollContainer.addSubview(label)
//        label.topAnchor.constraint(equalTo: featuredArtists.bottomAnchor, constant: 20).isActive = true
        
        primaryScrollContainer.addSubview(trackHistory)
        trackHistory.setRootView(view: self.navigationController!)
        trackHistory.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
    }
    func setupDiscovery(){
       let label = Label()
        label.configure(text: "Fresh Drops", withNavButton: true, view: self.navigationController)
        
        primaryScrollContainer.addSubview(label)
        label.topAnchor.constraint(equalTo: trackHistory.bottomAnchor, constant: 20).isActive = true
        
        primaryScrollContainer.addSubview(albumSlider)
        albumSlider.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        

        
    }
    func setupPlaylist(){
        
        let label = Label()
        label.configure(text: "Playlist", withNavButton: true, view: self.navigationController)
        
        primaryScrollContainer.addSubview(label)
        label.topAnchor.constraint(equalTo: albumSlider.bottomAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: primaryScrollContainer.leadingAnchor).isActive = true
        
        primaryScrollContainer.addSubview(playlists)
        playlists.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        
    }

    
    // Present views
    
    @objc func showArtistReleases(){
        print("Artist Releases")

        let releases = ReleasesVc()
//        releases.modalPresentationStyle = .fullScreen
//        releases.modalTransitionStyle = .crossDissolve

        navigationController?.pushViewController(releases, animated: true)

    }
    
    // Handle Search bar
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let vc = searchController.searchResultsController as? RVC
        vc?.view.backgroundColor = .systemRed
        print(text)
    }
    
    // Navigation Bar components
    let userAvi: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "jazz")
        img.layer.cornerRadius = 15
        img.heightAnchor.constraint(equalToConstant: 30).isActive = true
        img.widthAnchor.constraint(equalToConstant: 30).isActive = true
        img.clipsToBounds = true
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.7).cgColor
        return img
    }()
}

