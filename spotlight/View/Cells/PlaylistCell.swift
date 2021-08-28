//
//  PlaylistCell.swift
//  spotlight
//
//  Created by Robert Aubow on 6/29/21.
//

import UIKit

//class PlaylistCell: UITableViewCell {
//    static let identifier = "playlistCell"
//    
//    let container: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
////        view.backgroundColor = .cyan
//        
//        return view
//    }()
//    
//    let playlistLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Playlists"
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Helvetica Neue", size: 20)
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        return label
//    }()
//    let morePlaylists: UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
//        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    let playlistSlider: UIScrollView = {
//        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        view.showsHorizontalScrollIndicator = false
////        view.backgroundColor = .red
//        return view
//    }()
//    let playlistStack: UIStackView = {
//        let view = UIStackView()
//        view.alignment = .fill
//        view.distribution = .fillEqually
//        view.axis = .horizontal
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.spacing = 20
//        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        view.widthAnchor.constraint(equalToConstant: 2500).isActive = true
//        return view
//    }()
//    
//    func configure(){
//        configurePlaylists()
//    }
//    
//    func configurePlaylists(){
//        contentView.addSubview(container)
//        container.addSubview(playlistLabel)
//        playlistLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
//        playlistLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
//        
//        container.addSubview(morePlaylists)
//        morePlaylists.leadingAnchor.constraint(equalTo: playlistLabel.trailingAnchor, constant: 20).isActive = true
//        morePlaylists.bottomAnchor.constraint(equalTo: playlistLabel.bottomAnchor).isActive = true
//
//        container.addSubview(playlistSlider)
//        playlistSlider.topAnchor.constraint(equalTo: playlistLabel.bottomAnchor, constant: 20).isActive = true
//        playlistSlider.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
//        
//        playlistSlider.addSubview(playlistStack)
//        playlistStack.leadingAnchor.constraint(equalTo: playlistSlider.leadingAnchor, constant: 20).isActive = true
//        
//        let playlist = Playlist(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        playlist.setupImage(image: UIImage(named:"a8f3ab0c-9859-43b7-bc66-a3c8c81ca525_rw_1920")!)
//        
//        let playlist1 = Playlist(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        playlist1.setupImage(image: UIImage(named:"ab67706c0000bebbd8f8f27426ae64c151e39632")!)
//        
//        let playlist2 = Playlist(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        playlist2.setupImage(image: UIImage(named:"258febf29bf4a0f4d42842658006579b")!)
//        
//        let playlist3 = Playlist(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        playlist3.setupImage(image: UIImage(named:"90s+R&B+Playlist+Cover+2")!)
//        
//        let playlist4 = Playlist(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        playlist4.setupImage(image: UIImage(named:"rock")!)
//        
//        let playlist5 = Playlist(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        playlist5.setupImage(image: UIImage(named:"spotify06")!)
//        
//        let playlists = [playlist, playlist1, playlist2, playlist3, playlist4, playlist4, playlist5]
//        
//        for i in 0..<playlists.count{
//            playlistStack.addArrangedSubview(playlists[i])
//        }
//
//    }
//    
//    override func layoutSubviews() {
//        playlistSlider.contentSize = CGSize(width: 2550, height: 0)
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
