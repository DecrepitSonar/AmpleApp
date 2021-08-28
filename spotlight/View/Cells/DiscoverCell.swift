//
//  DiscoverCell.swift
//  spotlight
//
//  Created by Robert Aubow on 6/29/21.
//

import UIKit

class DiscoverCell: UITableViewCell {
    static let identifier = "discoverCell"
    let container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 315))
//        view.backgroundColor = .lightGray
        return view
    }()
    let albumSliderContainer: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 220).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        view.backgroundColor = .red
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    let discoverLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let discoverMore: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(presentDiscoverVc), for: .touchUpInside)
        return btn
    }()
    let discoverStack: UIStackView = {
        let view = UIStackView()
        view.heightAnchor.constraint(equalToConstant: 220).isActive = true
        view.widthAnchor.constraint(equalToConstant: 3000).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
//        view.backgroundColor = .green
        view.spacing = 20
        return view
    }()
    
    func configure(){
       configureComponent()
    }
    
    @objc private func presentDiscoverVc(){
        print("Discover")
    }
    
    @objc private func presentTrackDetail(){
        print("Discover Track")
    }
    private func configureComponent(){
        contentView.addSubview(container)
        container.addSubview(discoverLabel)
        discoverLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        discoverLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        
        container.addSubview(discoverMore)
        discoverMore.leadingAnchor.constraint(equalTo: discoverLabel.trailingAnchor, constant: 20).isActive = true
        discoverMore.bottomAnchor.constraint(equalTo: discoverLabel.bottomAnchor).isActive = true

        container.addSubview(albumSliderContainer)
        albumSliderContainer.topAnchor.constraint(equalTo: discoverLabel.bottomAnchor, constant: 20).isActive = true
        albumSliderContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        
        albumSliderContainer.addSubview(discoverStack)
        discoverStack.leadingAnchor.constraint(equalTo: albumSliderContainer.leadingAnchor, constant: 20).isActive = true
        
        let album = MediumAlbumComponent()
        album.setupAlbum(image: UIImage(named: "cleanup")!, artist: "Joel", name: "Clean up")
        
        let album1 = MediumAlbumComponent()
        album1.setupAlbum(image: UIImage(named: "whatkindofmusic")!, artist: "Tom Mich Yusif Dayes", name: "What Kind of Music")
        
        let album2 = MediumAlbumComponent()
        album2.setupAlbum(image: UIImage(named: "chasingsummer")!, artist: "S.I.R.", name: "Chasing Summer")
        
        let album3 = MediumAlbumComponent()
        album3.setupAlbum(image: UIImage(named: "1123")!, artist: "Bj The Chicago Kid", name: "1123")
        
        let album4 = MediumAlbumComponent()
        album4.setupAlbum(image: UIImage(named: "Painted-Lucky-Daye")!, artist: "Lucky Daye", name: "painted")
        
        let album5 = MediumAlbumComponent()
        album5.setupAlbum(image: UIImage(named: "Kehlani_-_While_We_Wait")!, artist: "Kehlani", name: "While We Wait")
        
        let album6 = MediumAlbumComponent()
        album6.setupAlbum(image: UIImage(named: "major")!, artist: "Childish Major", name: "Dirt Roda Diamond")
        
        let album7 = MediumAlbumComponent()
        album7.setupAlbum(image: UIImage(named: "dakid")!, artist: "Sy Ari Da Kid", name: "Anti Industry Me")
        
        let albums = [album, album1, album2, album3, album4, album5, album5, album6, album7]
        
        for i in 0..<albums.count {
            discoverStack.addArrangedSubview(albums[i])
        }
    }
    override func layoutSubviews() {
        albumSliderContainer.contentSize = CGSize(width: 3050, height: 0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
