//
//  DetailViewController.swift
//  spotlight
//
//  Created by bajo on 2022-01-23.
//

import UIKit
import CoreAudio

class DetailViewController: UIViewController {

    var albumId = String()
    var data: Album?
    var tableview: UITableView!
    let user = UserDefaults.standard.object(forKey: "userdata")

    var loadingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .red
        
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(loadingView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.Get(url: "album?albumId=\(albumId)") { (data: Album?, error: NetworkError) in
            switch(error){
            case .servererr:
                print(error.localizedDescription)
            
            case .success:
                
                self.data = data!
                
                DispatchQueue.main.async {
                    self.loadingView.removeFromSuperview()
                    
                    self.loadTableview()
                }
                
            case .notfound:
                print(error.localizedDescription)
            }
        }
    }
    
    
    func loadTableview(){
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.frame
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.separatorColor = UIColor.clear
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        tableview.contentInsetAdjustmentBehavior = .never
        tableview.allowsSelection = true
        setupHeader()
        
        view.addSubview(tableview)
        
    }
    func setupHeader(){
       
        let header = DetailHeaders(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 640))
        header.artist.text = data?.name
        header.albumImage.setUpImage(url: data!.imageURL!)
        header.imageContainer.setUpImage(url: data!.imageURL!)
        header.trackTitle.text = data?.title
        header.artistAviImage.setUpImage(url: data!.artistImgURL!)
        header.vc = navigationController
        
        header.artistId = data!.artistId!
        self.tableview.tableHeaderView = header
        
        header.album = data
        header.checkIfAlbumIsSaved()
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.items!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tracks"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let date = Date()
        let publishDate = date.formateDate(dateString: data!.releaseDate!)
        
        
        return "Published \(publishDate)"
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

         let favouritAction = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
             print(self.data!.items![indexPath.row])
             
             NetworkManager.Post(url: "user/savedTracks?user=\(self.user!)", data: self.data!.items![indexPath.row]) { ( data: Bool?, error: NetworkError) in
                 switch(error){
                 case .notfound:
                     print("url not found")
                
                 case .servererr:
                     print("Internal server error")
                     
                 case .success:
                     DispatchQueue.main.async {
                         self.tableview.reloadRows(at: [indexPath], with: .left)
                     }
                     print("success")
                 }
             }
        }
        
        favouritAction.image = UIImage(systemName: "suit.heart")
        favouritAction.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        
        return UISwipeActionsConfiguration(actions: [favouritAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AudioManager.initPlayer(track: data!.items![indexPath.row], tracks: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track" : data!.items![indexPath.row]])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as! TrackCell
        cell.configure(with: data!.items![indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    
}
