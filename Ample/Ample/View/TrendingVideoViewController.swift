//
//  ViewController.swift
//  Ample
//
//  Created by bajo on 2022-07-29.
//

import UIKit

class TrendingVideoViewController: UIViewController {

    var tableView: UITableView!
    var videos: [VideoItemModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trending Videos"

        NetworkManager.Get(url: "videos/trending") { (data: [VideoItemModel]?, error: NetworkError) in
            
            switch( error ){
            case .notfound:
                print("")
            case .servererr:
                print("")
            case .success:
                self.videos = data!
                
                DispatchQueue.main.async {
                    self.initTableView()
                }
            }
        }
        
    }
    
    func initTableView(){
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoCollectionCell.self, forCellReuseIdentifier: VideoCollectionCell.reuseIdentifier)
        tableView.separatorColor = .clear
        view.addSubview(tableView)
        
    }

}

extension TrendingVideoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoCollectionCell.reuseIdentifier, for: indexPath) as! VideoCollectionCell
        cell.initialize(item: videos[indexPath.row], navigationController: nil)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
}


class VideoCollectionCell: UITableViewCell {
    
    static let reuseIdentifier: String = "video Collection cell"
    
    
    func initialize(item: VideoItemModel, navigationController: UINavigationController?){
        
        backgroundColor = .clear
        
        let contentDescriptionCell = UIStackView(arrangedSubviews: [videoTitleLabel, videoArtistNameLabel, videoViewCount])
        contentDescriptionCell.translatesAutoresizingMaskIntoConstraints = false
        contentDescriptionCell.axis = .vertical
        contentDescriptionCell.spacing = 2
        
        videoTitleLabel.text = item.title
        videoArtistNameLabel.text = item.artist
        videoViewCount.text = String(item.views!)
        
        image.setUpImage(url: item.posterURL!, interactable: false)
        
        addSubview(image)
        addSubview(contentDescriptionCell)
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: 125),
            
            image.widthAnchor.constraint(equalToConstant: 170),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
        
            contentDescriptionCell.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            contentDescriptionCell.topAnchor.constraint(equalTo: image.topAnchor),
            contentDescriptionCell.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    let image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        
        return label
    }()
    let videoArtistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 12)
        
        return label
    }()
    let videoViewCount: UILabel = {
        let label = UILabel()
        label.textColor = .tertiaryLabel
        label.setFont(with: 10)
        
        return label
    }()
}
