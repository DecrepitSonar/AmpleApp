//
//  SearchResultViewController.swift
//  spotlight
//
//  Created by bajo on 2021-12-11.
//

import UIKit

class SearchResultViewController: UIViewController {

    var tableview: UITableView!
    var searchQuery = ""
    
    var data = [LibItem](){
        didSet{
            tableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.frame = view.frame
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.separatorColor = UIColor.clear
        tableview.allowsSelection = true

        view.addSubview(tableview)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        tableview.register(AviTableCell.self, forCellReuseIdentifier: AviTableCell.reuseIdentifier)
        
    }
    
    func updateSearchHistory(item: LibItem){
        
        NetworkManager.Post(url: "user/history", data: item) { (data: LibItem?, error: NetworkError) in
            switch(error){
            case .notfound:
                print("url not found")
                
            case .servererr:
                print("Internal server error")
                
            case .success:
                print("success")
            }
        }
        
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(data.count > 0){
            return data.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = data[indexPath.row].type
        
        switch(type){
        case "Artist":
            
            let profile = ProfileViewController()
            
            print("Artist")
            profile.artistId = data[indexPath.row].id
            print(data[indexPath.row])
            
            updateSearchHistory(item: data[indexPath.row])
            
            presentingViewController?.navigationController?.pushViewController(profile, animated: true)
            
            
        case "Album":
        
            let detailVc = DetailViewController()
            print(data[indexPath.row])
            detailVc.albumId = data[indexPath.row].id
            
            presentingViewController?.navigationController?.pushViewController(detailVc, animated: true)
            
            updateSearchHistory(item: data[indexPath.row])
            
        case "Track":
            print("Track")
            let item = data[indexPath.row]
            
            let track = Track(id: item.id,
                              type: item.type,
                              trackNum: nil,
                              title: item.title!,
                              artistId: item.artistId!,
                              name: item.name!,
                              imageURL: item.imageURL,
                              albumId: item.albumId!,
                              audioURL: item.audioURL!,
                              playCount: nil)
            
            AudioManager.shared.initPlayer(track: track, tracks: nil)
            
            NetworkManager.Post(url: "/user/history", data: data[indexPath.row]) { (data: Track?, error: NetworkError) in
                switch(error){
                case .servererr:
                    print("Internal error")
                
                case .notfound:
                    print("Url not found")
                    
                case .success:
                    return
                }
            }
            
            updateSearchHistory(item: data[indexPath.row])
            
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(data.count > 0){
            switch(data[indexPath.row].type){
            case "Artist":
                return configureTableCell(tableview: tableView, AviTableCell.self, with: data[indexPath.row], indexPath: indexPath)
                
            default:
                return configureTableCell(tableview: tableView, TrackStrip.self, with: data[indexPath.row], indexPath: indexPath)
            }
        }
        else{
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel!.text = "No results found for \"\(searchQuery)\""
            return cell
        }
        
    }
    
}

func configureTableCell<T: TableCell>( tableview: UITableView, _ cellType: T.Type, with item: LibItem, indexPath: IndexPath) -> T{

    guard let cell = tableview.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
        fatalError("")
    }
    
    switch(item.type){
        
    case "Artist":
        cell.configureWithSet(image: item.imageURL, name: "", artist: item.name!, type: item.type!)

    default:
        cell.configureWithSet(image: item.imageURL, name: item.title!, artist: item.name!, type: item.type!)
    }
    
    
    return cell

}
