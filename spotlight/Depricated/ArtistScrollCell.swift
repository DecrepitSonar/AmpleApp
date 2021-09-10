////
////  HeaderFeatureCell.swift
////  spotlight
////
////  Created by Robert Aubow on 6/28/21.
////
//
//import UIKit
//
//class ArtistScrollCell: UITableViewCell {
//    static let identifier = "ArtistComponent"
//    
//    let container: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180))
////        view.backgroundColor = .orange
//        return view
//    }()
//    
//    let artistsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "New Releases from your artists"
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Helvetica Neue", size: 20)
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        return label
//    }()
//    let artistMoreBtn: UIButton = {
//        let btn = UIButton()
//        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
//        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    let artistScrollContainer: UIScrollView = {
//        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.showsHorizontalScrollIndicator = false
////        view.backgroundColor = .green
//        return view
//    }()
//    let artistStack: UIStackView = {
//        let view = UIStackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.spacing = 0
//        view.distribution = .fillEqually
//        view.alignment = .leading
//        view.axis = .horizontal
////        view.backgroundColor = .red
//        return view
//    }()
//    
//    func configure(){
//        configureComponent()
//    }
//
//    private func configureComponent(){
//        contentView.addSubview(container)
//        container.addSubview(artistsLabel)
//        artistsLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
//        artistsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant:  20).isActive = true
//        
//        container.addSubview(artistMoreBtn)
//        artistMoreBtn.leadingAnchor.constraint(equalTo: artistsLabel.trailingAnchor, constant: 20).isActive = true
//        artistMoreBtn.bottomAnchor.constraint(equalTo: artistsLabel.bottomAnchor).isActive = true
//        
//        artistMoreBtn.addTarget(self, action: #selector(showArtistReleases), for: .touchUpInside)
//        
//        container.addSubview(artistScrollContainer)
//        
//        artistScrollContainer.topAnchor.constraint(equalTo: artistsLabel.bottomAnchor, constant: 20).isActive = true
//        artistScrollContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        artistScrollContainer.heightAnchor.constraint(equalToConstant: 125).isActive = true
//        
//        artistScrollContainer.addSubview(artistStack)
//        
//        artistStack.leadingAnchor.constraint(equalTo: artistScrollContainer.leadingAnchor, constant: 20).isActive = true
//
//        artistStack.widthAnchor.constraint(equalToConstant: 900).isActive = true
//        artistStack.heightAnchor.constraint(equalToConstant: 125).isActive = true
//        
//        let artist = UserAViReleaseAvi()
//        artist.setupAvi(image: UIImage(named: "meg")!, username: "Meg Thee Stallion")
//        
//        let artist1 = UserAViReleaseAvi()
//        artist1.setupAvi(image: UIImage(named: "drake")!, username: "Drake")
//        
//        let artist2 = UserAViReleaseAvi()
//        artist2.setupAvi(image: UIImage(named: "phoenypPl")!, username: "Phoney Ppl")
//        
//        let artist3 = UserAViReleaseAvi()
//        artist3.setupAvi(image: UIImage(named: "kehlani")!, username: "Meg Thee Stallion")
//        
//        let artist4 = UserAViReleaseAvi()
//        artist4.setupAvi(image: UIImage(named: "6lack1")!, username: "6lack")
//        
//        let artist5 = UserAViReleaseAvi()
//        artist5.setupAvi(image: UIImage(named: "kali")!, username: "Kali Uchis")
//        
//        let artist6 = UserAViReleaseAvi()
//        artist6.setupAvi(image: UIImage(named: "umi")!, username: "Umi")
//        
//        let artist7 = UserAViReleaseAvi()
//        artist7.setupAvi(image: UIImage(named: "lucky")!, username: "Lucky Daye")
//        
//        let artists = [artist, artist1, artist2, artist3, artist4, artist5, artist6, artist7]
//        
//        for i in 0..<artists.count{
//            artistStack.addArrangedSubview(artists[i])
//            let artistGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(showArtistProfile))
//            artists[i].addGestureRecognizer(artistGestureRecogizer)
//        }
//        
//    }
//    
//    @objc private func showArtistReleases(){
//        print("Artist Releases")
//        
//        let releases = ReleasesVc()
//        releases.modalPresentationStyle = .fullScreen
//        releases.modalTransitionStyle = .crossDissolve
//        
//    }
//    
//    @objc private func showArtistProfile(){
//        print("Arttist Profile")
//        
//        let artistVc = ArtistProfileVc()
//        
//        artistVc.modalPresentationStyle = .fullScreen
//        artistVc.modalTransitionStyle = .crossDissolve
//        
//        window?.rootViewController?.present(artistVc, animated: true)
//    }
//    
//    override func layoutSubviews() {
//        artistScrollContainer.contentSize = CGSize(width: 950, height: 0)
////        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0))
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
