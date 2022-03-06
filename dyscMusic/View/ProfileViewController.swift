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
//        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = false
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
        tableview.contentInsetAdjustmentBehavior = .never
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.separatorColor = UIColor.clear
        tableview.bounces = false
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        tableview.register(TrackWithPlayCount.self, forCellReuseIdentifier: TrackWithPlayCount.reuseIdentifier)
        tableview.register(AlbumFlowSection.self, forCellReuseIdentifier: AlbumFlowSection.reuseIdentifier)
        
//        header.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        view.backgroundColor = .red
        initHeader()
//        tableview.backgroundView = header
        tableview.tableHeaderView = header
        
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
        
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let offset = tableview.contentOffset.y
//
////        print(offset)
//
//        if(offset < 350 ){
//            header.image.center.y =  header.center.y + offset
//            return
//        }
//
//    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 200
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let items = data.items[indexPath.section].items
        
        switch indexPath.section {
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: TrackWithPlayCount.reuseIdentifier, for: indexPath) as! TrackWithPlayCount
            cell.configure(with: items![indexPath.row])
            cell.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
            cell.selectionStyle = .none
            return cell
            
        default:
            let cell = tableview.dequeueReusableCell(withIdentifier: AlbumFlowSection.reuseIdentifier, for: indexPath) as! AlbumFlowSection
            cell.configure(data: items!, navigationController: self.navigationController!)
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data.items[indexPath.section].items![indexPath.row]
        
        let track = Track(id: item.id,
                          type: item.type,
                          trackNum: UInt(item.trackNum!),
                          title: item.title!,
                          artistId: item.artistId!,
                          name: item.name!,
                          imageURL: item.imageURL,
                          albumId: item.albumId!,
                          audioURL: item.audioURL,
                          playCount: Int(item.playCount!))
        
        AudioManager.shared.initPlayer(track: track, tracks: nil)
    }
}
