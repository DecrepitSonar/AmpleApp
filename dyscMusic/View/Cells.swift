//
//  CollectionViewCells.swift
//  spotlight
//
//  Created by Robert Aubow on 8/14/21.
//

import Foundation
import UIKit

class FeaturedHeader: UICollectionViewCell, Cell{

    static var reuseIdentifier: String = "Featured Header"
    var tapGesture = CustomGestureRecognizer()
    var NavVc: UINavigationController?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        title.font = UIFont.boldSystemFont(ofSize: 20)
        
        let stackview = UIStackView(arrangedSubviews: [image])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        
        contentView.addSubview(image)
        image.addGestureRecognizer(tapGesture)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
//
//        stackview.axis = .vertical
//        stackview.spacing = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        self.NavVc = rootVc
        
//        image.image = UIImage(named: catalog.imageURL)
        image.setUpImage(url: catalog.imageURL)
       
        tapGesture.id = catalog.id
        
        title.text = catalog.title
        
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = DetailViewController()
        view.albumId = _sender.id!
        
        print("presenting...")
        NavVc!.title = "Featured"
        NavVc!.pushViewController(view, animated: true)
        
    }
    
    let tagline = UILabel()
    let image: UIImageView = {
        
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        
        return image
    }()
    let title = UILabel()
    
}
class ArtistSection: UICollectionViewCell,  Cell{
    
    static var reuseIdentifier: String = "Artist Section"
    
    var NavVc: UINavigationController?
    var tapGesture: CustomGestureRecognizer!
    
    let image = UIImageView()
    let label = UILabel()
    
    let artistAvi = AViCard()
    
    var stackview: UIStackView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.isUserInteractionEnabled = true
        stackview = UIStackView(arrangedSubviews: [artistAvi])
        stackview.axis = .vertical
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?){
        
        self.NavVc = rootVc!
    
        print("Seting up Artist")
        artistAvi.configureCard(img: catalog.imageURL, name: catalog.name!)
        print(catalog)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapGesture.id = catalog.id
        artistAvi.addGestureRecognizer(tapGesture)
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = ProfileViewController()
        view.artistId = _sender.id
        
        NavVc?.pushViewController(view, animated: true)
        
    }
}
class TrendingSection: UICollectionViewCell, Cell{
  
    static let reuseIdentifier: String = "Trending"
    
    var vc: UINavigationController?
    var tapGesture: CustomGestureRecognizer?
    
    let chartPosition = UILabel()
    let image = UIImageView()
    let title = UILabel()
    let artist = UILabel()
    let listenCount = UILabel()
    var track: Track!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
//        image.layer.cornerRadius = 10
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        title.setFont(with: 12)
        
        artist.setFont(with: 10)
        artist.textColor = .secondaryLabel
        
        listenCount.setFont(with: 10)
        listenCount.textColor = .secondaryLabel
        listenCount.textAlignment = .right
//        listenCount.numberOfLines = 0
        listenCount.translatesAutoresizingMaskIntoConstraints = false
        listenCount.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        chartPosition.setFont(with: 10)
        chartPosition.textColor = .secondaryLabel
        
        let innterStackview = UIStackView(arrangedSubviews: [title, artist])
        innterStackview.axis = .vertical
        innterStackview.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [image, innterStackview, listenCount] )
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillProportionally
        stackview.spacing = 10
        
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        
            listenCount.leadingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: -38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        vc = rootVc!
        
        track = Track(id: catalog.id, title: catalog.title!, artistId: catalog.artistId!, name: catalog.name!, imageURL: catalog.imageURL, albumId: catalog.albumId!, audioURL: catalog.audioURL)
        
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapGesture?.track = track
        self.addGestureRecognizer(tapGesture!)
        
        image.setUpImage(url: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: catalog.playCount!), number: .decimal)
        
    
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        print("playing selected item")
        AudioManager.shared.initPlayer(track: track, tracks: nil)
    }
}
class MediumImageSlider: UICollectionViewCell, Cell{
    
    static let reuseIdentifier: String = "MediumSlider"
    
    var vc: UINavigationController?
    var tapgesture: CustomGestureRecognizer?
    var type: String?
    
    let image = UIImageView()
    let artist = UILabel()
    let title = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        artist.textColor = .secondaryLabel
        artist.translatesAutoresizingMaskIntoConstraints = false
        artist.setFont(with: 10)
        
        title.textColor = .label
        title.setFont(with: 12)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [image, title, artist])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 0
        
        addSubview(stackview)
        NSLayoutConstraint.activate([
            
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150),
            
//            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),
            
            artist.topAnchor.constraint(equalTo: title.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        vc = rootVc!
        type = catalog.type
        
        tapgesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapgesture!.id = catalog.id
        
        addGestureRecognizer(tapgesture!)
        
        image.setUpImage(url: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
    }
    
    func didTap(_sender: CustomGestureRecognizer) {

        print(_sender.id!)
        
        
        switch( type){
        case "Playlist":
            let view = PlaylistViewController()
            view.id = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        default:
            let view = DetailViewController()
            view.albumId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        }
        
    }
}
class TrackHistorySlider: UICollectionViewCell, Cell {
    
    static let reuseIdentifier: String = "History cell"
    
    var vc: UINavigationController?
    var tapgesture: CustomGestureRecognizer?
    
    let image = UIImageView()
    let artist = UILabel()
    let title = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.clipsToBounds = true
//        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        artist.textColor = .secondaryLabel
        artist.translatesAutoresizingMaskIntoConstraints = false
        artist.setFont(with: 10)
        
        title.textColor = .label
        title.setFont(with: 12)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [image, title, artist])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 0
        
        addSubview(stackview)
        NSLayoutConstraint.activate([
            
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150),
            
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),
            
            artist.topAnchor.constraint(equalTo: title.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        vc = rootVc!
        
        tapgesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapgesture!.id = catalog.id
        
        addGestureRecognizer(tapgesture!)
        
        image.setUpImage(url: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        print("History Track")
    }
}
class LargeArtistAvi: UICollectionViewCell, Cell {
    
    static var reuseIdentifier: String = "largeArtistAvi"
    
    var gesture: CustomGestureRecognizer!
    var vc: UINavigationController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContainer()
        
        NSLayoutConstraint.activate([
        
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            artistLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            artistLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            
            options.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            options.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            
//            followBtn.bottomAnchor.constraint(equalTo: artistLabel.topAnchor, constant: 5),
//            followBtn.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10)
            
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        image.setUpImage(url: item.imageURL)
        artistLabel.text = item.name
        
        gesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        gesture.id = item.id
        
        self.vc = rootVc
        container.addGestureRecognizer(gesture)
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let profile = ProfileViewController()
        profile.artistId = _sender.id
        print("pressed")
        vc.pushViewController(profile, animated: true)
    }
    
    func setupContainer(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.2, 1.3]
        
        contentView.addSubview(image)
        addSubview(container)
        
        container.layer.zPosition = 2
        
        gradientLayer.frame = frame
        container.layer.addSublayer(gradientLayer)

        container.addSubview(artistLabel)
        artistLabel.layer.zPosition = 2
        container.addSubview(options)
//        container.addSubview(followBtn)
    }
    
    let image: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        
        return img
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(with: 15)
        label.tintColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let options: UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        return btn
    }()
    
    let followBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.setFont(with: 15)
//        btn.layer.borderColor = UIColor.red.cgColor
//        btn.layer.borderWidth = 1
//        btn.layer.cornerRadius = 10
//        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
//        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
//        btn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return btn
    }()
}

// Track Overview Cells
class TrackDetailStrip: UICollectionViewCell, Cell{
    static var reuseIdentifier: String = "track"
    
    var vc: UINavigationController?
    
    var tapGesture: CustomGestureRecognizer!
    var options: CustomGestureRecognizer!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        options = CustomGestureRecognizer(target: self, action: #selector(openOptionsView(_sender:)))
        
        let labelStack = UIStackView(arrangedSubviews: [trackTitleLabel, artistNameLabel])
        labelStack.axis = .vertical
        
        let horizontalStack = UIStackView(arrangedSubviews: [labelStack, optionsBtn])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10

        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
//            trackImage.heightAnchor.constraint(equalToConstant: 50),
//            trackImage.widthAnchor.constraint(equalToConstant: 50),
//            trackImage.leadingAnchor.constraint(equalTo: optionsBtn.trailingAnchor, constant: 7),
            
            optionsBtn.widthAnchor.constraint(equalToConstant: 30 ),
            optionsBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        vc = rootVc
        
        trackImage.setUpImage(url: item.imageURL)
        trackTitleLabel.text = item.title
        artistNameLabel.text = item.name
        
        let track = Track(id: item.id,
                          title: item.title!,
                          artistId: item.artistId!,
                          name: item.name!,
                          imageURL: item.imageURL,
                          albumId: item.albumId!,
                          audioURL: item.audioURL!)
        
        tapGesture.track = track
        addGestureRecognizer(tapGesture)
        
        options.track = track
        optionsBtn.addGestureRecognizer(options)
        
        optionsBtn.addTarget(self, action: #selector(openOptionsView(_sender:)), for: .touchUpInside)
    }
    
    @objc func openOptionsView(_sender: CustomGestureRecognizer){
        let view = TrackOptionsViewController()
        vc?.present(view, animated: true)
    }
    
    @objc func didTap(_sender: CustomGestureRecognizer){
        
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track" : _sender.track! as Track])
    }
    
    var trackImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.clipsToBounds = true
        
        return image
    }()
    
    var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 10)
        
        return label
    }()
    var trackTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 12)
        
        return label
    }()
    
    let optionsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .secondaryLabel
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    
    
} // depricated

class TrackCell: UITableViewCell{
    static var reuseIdentifier: String = "track"
    
    var tapGesture: CustomGestureRecognizer!
    var options: CustomGestureRecognizer!
    var user = UserDefaults.standard.object(forKey: "userdata")
    var isSaved: Bool = false
    var track: Track!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        options = CustomGestureRecognizer(target: self, action: #selector(openOptionsView(_sender:)))
        
        let labelStack = UIStackView(arrangedSubviews: [trackTitleLabel, artistNameLabel])
        labelStack.axis = .vertical
        
        selectionStyle = .none
        
        let horizontalStack = UIStackView(arrangedSubviews: [labelStack, likedBtn, optionsBtn])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10

        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
//            trackImage.heightAnchor.constraint(equalToConstant: 50),
//            trackImage.widthAnchor.constraint(equalToConstant: 50),
//            trackImage.leadingAnchor.constraint(equalTo: optionsBtn.trailingAnchor, constant: 7),
//
            optionsBtn.widthAnchor.constraint(equalToConstant: 30 ),
            optionsBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        optionsBtn.addTarget(self, action: #selector(openOptionsView(_sender:)), for: .touchUpInside)
        likedBtn.addTarget(self, action: #selector(toggleSave), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    
    func configure(with item: Track) {
        
        track = item
        
        trackImage.setUpImage(url: item.imageURL)
        trackTitleLabel.text = item.title
        artistNameLabel.text = item.name
        
//        let track = Track(id: item.id,
//                          title: item.title!,
//                          artistId: item.artistId!,
//                          name: item.name!,
//                          imageURL: item.imageURL,
//                          albumId: item.albumId!,
//                          audioURL: item.audioURL!)
        
//        tapGesture.track = item
//        addGestureRecognizer(tapGesture)
        
//        options.track = item
//        optionsBtn.addGestureRecognizer(options)
        
        print("Initialized cell")
        
        NetworkManager.Get(url: "user/savedTracks?id=\(item.id)&&user=\(user!)") { (data: Data?, error: NetworkError) in
            switch( error ){
            case .servererr:
                print( "Internal server ")
            
            case .notfound:
                print( "url not found")
                
            case .success:
                
                DispatchQueue.main.async {
                    self.likedBtn.isHidden = false
                }
                
            }
        }
        
    }
    
    @objc func toggleSave(){
        
        if(!isSaved){
            NetworkManager.Post(url: "user/savedTracks?user=\(self.user!)", data: track) { ( data: Bool?, error: NetworkError) in
                switch(error){
                case .notfound:
                    print("url not found")
               
                case .servererr:
                    print("Internal server error")
                    
                case .success:
                    print("success")
                    
                    DispatchQueue.main.async {
                        self.likedBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        self.likedBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
                    }
                }
            }
        }
        else{
            NetworkManager.Delete(url: "user/savedTracks?user=\(self.user!)") { (error: NetworkError) in
                switch( error ){
                case .servererr:
                    print(" internal server error ")
                
                case .notfound:
                    print( "url not found")
                    
                case .success:
                    DispatchQueue.main.async {
                        self.likedBtn.isHidden = false
                    }
                }
            }
        }
        
        likedBtn.setNeedsDisplay()
    }
    
    @objc func openOptionsView(_sender: CustomGestureRecognizer){
        let view = TrackOptionsViewController()
//        vc?.present(view, animated: true)
    }
    
    @objc func didTap(_sender: CustomGestureRecognizer){
        
        AudioManager.shared.initPlayer(track: _sender.track, tracks: nil)
    }
    
    var trackImage: UIImageView = {
        var image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.clipsToBounds = true
        
        return image
    }()
    
    var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        return label
    }()
    var trackTitleLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .label
        label.setFont(with: 12)
        
        return label
    }()
    let likedBtn: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        view.isHidden = true
        view.layer.zPosition = 2

        return view
    }()
    let optionsBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .secondaryLabel
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    
}

// headers

class PlaylistsDetailHeader: UIView{
    
    static let reuseableIdentifier: String = "image Header"
    
    var tracks: [Track]!
    var vc: UINavigationController?
    var tapGesture: CustomGestureRecognizer!
    var artistId = String()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
//        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
//        artistAviImage.addGestureRecognizer(tapGesture!)

        playBtn.addTarget(self, action: #selector(playAllTracks), for: .touchUpInside)
        playBtn.isUserInteractionEnabled = true
        
        setupGradient()
        
        let btnStack = UIStackView(arrangedSubviews: [playBtn,shuffleBtn])
        btnStack.axis = .horizontal
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.distribution = .fillEqually
        btnStack.spacing = 10
        
        let ContainerStack = UIStackView(arrangedSubviews: [albumImage, trackTitle, btnStack])
        ContainerStack.translatesAutoresizingMaskIntoConstraints = false
        ContainerStack.axis = .vertical
        ContainerStack.spacing = 17
        ContainerStack.layer.zPosition = 3
        
        addSubview(ContainerStack)
        
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -100),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: -48),
            imageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
////
            container.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            container.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            albumImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
            albumImage.heightAnchor.constraint(equalToConstant: 355),
            albumImage.widthAnchor.constraint(equalToConstant:350),

            artistAviImage.heightAnchor.constraint(equalToConstant: 40),
            artistAviImage.widthAnchor.constraint(equalToConstant: 40),

            ContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ContainerStack.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 100),
            ContainerStack.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
////
            btnStack.trailingAnchor.constraint(equalTo: ContainerStack.trailingAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = Profile()
        view.artistId = artistId
        vc?.pushViewController(view, animated: true)
//        print("pressed")
    }

    @objc func playAllTracks(){
        AudioManager.shared.initPlayer(track: nil, tracks: tracks)
    }
    
    func setupGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5).cgColor]
        gradientLayer.locations = [0.2, 1.3]
        gradientLayer.frame = frame
        
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        addSubview(container)
        
        container.addSubview(imageContainer)
        container.frame = imageContainer.frame
        
        container.addSubview(visualEffectView)
        visualEffectView.frame = frame

        container.layer.zPosition = 1
        container.layer.addSublayer(gradientLayer)

    }
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageContainer: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let albumImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()
    let trackTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setFont(with: 25)
        label.numberOfLines = 0
        
        return label
    }()
    var playBtn: UIButton = {
        
        let btnConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let btnImage = UIImage(systemName: "play.fill", withConfiguration: btnConfig)
        
        let btn = UIButton()
        btn.setImage(btnImage, for: .normal)
        btn.setTitle("Play", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        btn.layer.cornerRadius = 5
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btn.layer.zPosition = 3

        return btn
    }()
    let shuffleBtn: UIButton = {
        
        let shuffleConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let shuffleImg = UIImage(systemName: "shuffle", withConfiguration: shuffleConfig)
        
        let btn = UIButton()
        btn.setTitle("Shuffle", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        btn.titleLabel?.setFont(with: 20)
        btn.setImage(shuffleImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return btn
    }()
    
    let artistAviImage: UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 1
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.isUserInteractionEnabled = true
        image.layer.zPosition = 1

        return image
    }()
    let artist: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageTag: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
} // Depricated
class DetailHeaders: UIView{
    
    static let reuseableIdentifier: String = "image Header"
    
    var tracks = [Track]()
    var vc: UINavigationController?
    var tapGesture: CustomGestureRecognizer!
    var artistId = String()
    var album: Album!
    
    var isSaved: Bool = false
    var isDownloaded: Bool?
    var addedToListQueue: Bool?
    
    let btnConfig = UIImage.SymbolConfiguration(pointSize: 20)
    let user = UserDefaults.standard.object(forKey: "userdata")
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        artistAviImage.addGestureRecognizer(tapGesture!)

        playBtn.addTarget(self, action: #selector(playAllTracks), for: .touchUpInside)
        playBtn.isUserInteractionEnabled = true
        
        setupGradient()
        
        let btnStack = UIStackView(arrangedSubviews: [playBtn,shuffleBtn])
        btnStack.axis = .horizontal
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.distribution = .fillEqually
        btnStack.spacing = 10

        let TirtiaryStack = UIStackView(arrangedSubviews: [likebtn, queueBtn, shareBtn, downloadBtn, ellipis])
        TirtiaryStack.axis = .horizontal
        TirtiaryStack.translatesAutoresizingMaskIntoConstraints = false
        TirtiaryStack.distribution = .equalCentering
        
        let SecondaryStack = UIStackView(arrangedSubviews: [artistAviImage,artist])
        SecondaryStack.axis = .horizontal
        SecondaryStack.alignment = .center
        SecondaryStack.distribution = .fill
        SecondaryStack.spacing = 10
        
        let ContainerStack = UIStackView(arrangedSubviews: [albumImage, TirtiaryStack,trackTitle, SecondaryStack, btnStack])
        ContainerStack.translatesAutoresizingMaskIntoConstraints = false
        ContainerStack.axis = .vertical
        ContainerStack.spacing = 17
        ContainerStack.layer.zPosition = 3
        
        addSubview(ContainerStack)
        
        likebtn.addTarget(self, action: #selector(savedBtnTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -100),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            imageContainer.topAnchor.constraint(equalTo: topAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
////
            container.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            albumImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
            albumImage.heightAnchor.constraint(equalToConstant: 355),
            albumImage.widthAnchor.constraint(equalToConstant:350),

            artistAviImage.heightAnchor.constraint(equalToConstant: 20),
            artistAviImage.widthAnchor.constraint(equalToConstant: 20),

            ContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ContainerStack.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 75),
            ContainerStack.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
////
            btnStack.trailingAnchor.constraint(equalTo: ContainerStack.trailingAnchor),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func savedBtnTapped(){

        
        if( !isSaved){
            NetworkManager.Post(url: "user/saved?userId=\(user!)", data: album) { (data: Data?, error: NetworkError) in
                
                switch(error){
                case .servererr:
                    print("Internal server error")
                
                case .notfound:
                    print("url not found")
                    
                case .success:
                    print("Post request successful")
                    self.isSaved = true
                    DispatchQueue.main.async {
                        self.likebtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        self.likebtn.reloadInputViews()
                    }
                }
            }
        }
        else{
            NetworkManager.Delete(url: "user/saved?userId=\(user!)&&id=\(album.id)") { err in
                switch( err ){
                case .servererr:
                    print( "Internal server error")
                
                case .notfound:
                    print( "Url not found")
                
                case .success:
                    print("Delete request successful")
                    self.isSaved = false
                    DispatchQueue.main.async {
                        self.likebtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
        }
        
        likebtn.setNeedsDisplay()
    }
    
    func checkIfAlbumIsSaved(){
        NetworkManager.Get(url: "user/saved?id=\(album.id)&&userId=\(user!)") { (data: Album?, error: NetworkError) in
            
            switch( error){
            case .servererr:
                print("Internal server error ")
            
            case .notfound:
                print("Path to url not found")
                
            case .success:
                print("success")
                DispatchQueue.main.async {
                    self.likebtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                
                self.isSaved = true
            }
        }
    }
    
    @objc func didTap(_sender: CustomGestureRecognizer) {
        let view = ProfileViewController()
        view.artistId = artistId
        vc?.pushViewController(view, animated: true)
    }

    @objc func playAllTracks(){
        
        AudioManager.shared.initPlayer(track: nil, tracks: tracks)

    }
    
    func setupGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.7).cgColor]
        gradientLayer.locations = [0.2, 1.3]
        gradientLayer.frame = frame
        
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        addSubview(container)
        
        container.addSubview(imageContainer)
        container.frame = imageContainer.frame
        
        container.addSubview(visualEffectView)
        visualEffectView.frame = frame

        container.layer.zPosition = 1
        container.layer.addSublayer(gradientLayer)

    }
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageContainer: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let albumImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()
    let trackTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setFont(with: 25)
        label.numberOfLines = 0
        
        return label
    }()
    
    let likebtn: UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        return btn
    }()
    let queueBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "list.triangle"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
    let shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
    let downloadBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
    let ellipis: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
  
    var playBtn: UIButton = {
        
        let btnConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let btnImage = UIImage(systemName: "play.fill", withConfiguration: btnConfig)
        
        let btn = UIButton()
        btn.setImage(btnImage, for: .normal)
        btn.setTitle("Play", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        btn.layer.cornerRadius = 5
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btn.layer.zPosition = 3

        return btn
    }()
    let shuffleBtn: UIButton = {
        
        let shuffleConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let shuffleImg = UIImage(systemName: "shuffle", withConfiguration: shuffleConfig)
        
        let btn = UIButton()
        btn.setTitle("Shuffle", for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        btn.layer.cornerRadius = 5
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        btn.titleLabel?.setFont(with: 20)
        btn.setImage(shuffleImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return btn
    }()
    
    let artistAviImage: UIImageView = {
        let image = UIImageView()
        image.layer.borderWidth = 1
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.isUserInteractionEnabled = true
        image.layer.zPosition = 1

        return image
    }()
    let artist: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePublished: UILabel = {
        let label = UILabel()
        label.setFont(with: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    let pageTag: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
}
class SectionHeader: UICollectionReusableView, GestureAction {
  
    static let reuseIdentifier: String = "sectionHeader"
    
    let title = UILabel()
    let tagline = UILabel()
    let moreBtn = UIButton()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
    
        tagline.textColor = .secondaryLabel
        tagline.font = UIFont.boldSystemFont(ofSize: 17)
        
        let stackView = UIStackView(arrangedSubviews: [tagline])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.spacing = 5
        
        NSLayoutConstraint.activate([
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
      
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
}
class SectionFooter: UICollectionReusableView, GestureAction {
  
    static let reuseIdentifier: String = "sectionFooter"
    
    let title = UILabel()
    let tagline = UILabel()
    let moreBtn = UIButton()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
    
        tagline.textColor = .secondaryLabel
        tagline.font = UIFont.boldSystemFont(ofSize: 17)
        
        let stackView = UIStackView(arrangedSubviews: [tagline])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.spacing = 5
        
        NSLayoutConstraint.activate([
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
      
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
}

// Profile VC Components
class ProfileHeader: UICollectionViewCell, Cell {
    
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
    
    static var reuseIdentifier: String =  "profile Header"
    
    let container = UIView(frame: .zero)
    
    var stack = UIStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(image)

        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {

        name.text = item.name!
        let subscribers = NumberFormatter.localizedString(from: NSNumber(value: item.subscribers!), number: NumberFormatter.Style.decimal)
        subscribersLabel.text = "Subscribers: \(subscribers)"

        image.setUpImage(url: item.imageURL)

        setupGradient()
    }

    func setupGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.2, 1.3]
        
        gradientLayer.frame = frame
        
        container.frame = frame
        
        addSubview(container)
        container.layer.addSublayer(gradientLayer)
        
        let stack = UIStackView(arrangedSubviews: [name, verifiedIcon ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10

        let containerStack = UIStackView(arrangedSubviews: [subscribersLabel, stack, followBtn  ])
        containerStack.axis = .vertical
        containerStack.alignment = .leading
        containerStack.spacing = 7
        containerStack.translatesAutoresizingMaskIntoConstraints = false
    
        container.addSubview(containerStack)
        
        containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

    }
    
    @objc func didTapFollowBtn() {
        
    }
    @objc func didTapInfoBtn(){
        
    }
    
    var image: UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    var name: UILabel = {
        let label = UILabel()
        label.setFont(with: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var artistAvi: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let followBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for:  .normal)
        btn.titleLabel!.setFont(with: 12)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didTapFollowBtn), for: .touchUpInside)
        return btn
        
    }()
    let optionsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    let verifiedIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        btn.titleLabel?.setFont(with: 5)
        return btn
    }()
    
    let subscribersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 10)
        return label
    }()
} // Depricated

class ProfileHead: UIView{
  
    static var reuseIdentifier: String =  "profile Header"
    var user = UserDefaults.standard.object(forKey: "userdata")
    
    var isFollowed = false
    var artist: Artist!
    
    let container = UIView(frame: .zero)
    
    var stack = UIStackView()
    
    var animator: UIViewPropertyAnimator!
    
    override init(frame: CGRect){
        super.init( frame: frame)
        
        backgroundColor = .red
        addSubview(image)
        layer.zPosition = -3
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func setupHeader(artist: Artist){
        
        self.artist = artist
        NetworkManager.Get(url: "user/subscriptions?id=\(artist.id)&&user=\(user!)") { ( result: Data?, error: NetworkError ) in
            switch(error){
            case .notfound:
            
                self.isFollowed = false
                DispatchQueue.main.async {
                    self.followBtn.setTitle("Follow", for: .normal)
                    self.followBtn.layer.borderWidth = 1
                    self.followBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
                }
            
            case .servererr:
                print("server error: ", error.localizedDescription)
            
            case .success:
                print("result")
                self.isFollowed = true
              
                DispatchQueue.main.async {
                    self.followBtn.setTitle("Following", for: .normal)
                    self.followBtn.layer.borderWidth = 0
                    self.followBtn.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
        
        setupGradient()
    }
    
    func setupGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.1, 1.3]
        
        gradientLayer.frame = frame
        
        container.frame = frame
        
        addSubview(container)
        container.layer.addSublayer(gradientLayer)
        
        let stack = UIStackView(arrangedSubviews: [name, verifiedIcon ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10

        let containerStack = UIStackView(arrangedSubviews: [subscribersLabel, stack, followBtn ])
        containerStack.axis = .vertical
        containerStack.alignment = .leading
        containerStack.spacing = 7
        containerStack.translatesAutoresizingMaskIntoConstraints = false
    
        container.addSubview(containerStack)
        container.addSubview(infoBtn)
        
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            infoBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 20),
            infoBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 20),
            infoBtn.heightAnchor.constraint(equalToConstant: 20),
            infoBtn.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func didTapFollowBtn() {
        
        if(!isFollowed){
            
            NetworkManager.Post(url: "user/subscriptions?id=\(user!)", data: artist) { ( data: Data?, error: NetworkError) in
                switch(error){
                case .notfound:
                    print("internal error")
                    
                case .servererr:
                    print("error")
                    
                case .success:
                    
                    self.isFollowed = true
                    DispatchQueue.main.async {
                        self.followBtn.setTitle("Following", for: .normal)
                        self.followBtn.layer.borderWidth = 0
                        self.followBtn.layer.borderColor = UIColor.clear.cgColor
                    }
                    
                }
            }
            
        }
        else{

            NetworkManager.Delete(url: "user/subscriptions?id=\(artist.id)&&user=\(user!)") { error in
                switch(error){
                case .servererr:
                    print("Internal server error")
                case .notfound:
                    print("could not complete request")
                
                case .success:
                    
                    self.isFollowed = false
                    DispatchQueue.main.async {
                        self.followBtn.setTitle("Follow", for: .normal)
                        self.followBtn.layer.borderWidth = 1
                        self.followBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
                    }
                    
                }
            }
            
        }
        
        followBtn.setNeedsDisplay()
    }
    
    @objc func didTapInfoBtn(){
        
    }
    
    var image: UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    var name: UILabel = {
        let label = UILabel()
        label.setFont(with: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var artistAvi: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let infoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "info.circle"), for: .normal)
        
        btn.tintColor = .red
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let followBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for:  .normal)
        btn.titleLabel!.setFont(with: 12)
        btn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(didTapFollowBtn), for: .touchUpInside)
        
        return btn
        
    }()
    let optionsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    let verifiedIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        btn.titleLabel?.setFont(with: 5)
        return btn
    }()
    let subscribersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 10)
        return label
    }()
}
class ProfileContentSection: UITableViewCell {
    
    static let reuseIdentifier: String = "Sections"
    var navigationController: UINavigationController!
    
    var section = [LibObject](){
        didSet{
            initCollectionView()
        }
    }
    
    var collectionview: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func initCollectionView(){
        collectionview = UICollectionView(frame: contentView.bounds, collectionViewLayout: compositionalLayout())
        collectionview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        // register cells
        collectionview.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        collectionview.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        collectionview.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionview.register(ProfileHeader.self, forCellWithReuseIdentifier: ProfileHeader.reuseIdentifier)
        
        collectionview.contentInsetAdjustmentBehavior = .never
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        // Headers
        collectionview.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        collectionview.isScrollEnabled = false
        addSubview( collectionview)
        
        createDataSource()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func compositionalLayout() -> UICollectionViewLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { IndexPath, layoutEnvironement in
            let section = self.section[IndexPath]
            
            switch(section.type){
            case "Header":
                return LayoutManager.createHeaderLayout(using: section)
            case "Artist":
                return LayoutManager.createAviSliderSection(using: section)
            case "Tracks":
                return LayoutManager.createSmallProfileTableLayout(using: section)
            default:
                return LayoutManager.createMediumImageSliderSection(using: section)
            }
        }
        
        return compositionalLayout
    }
    
    func reloadData(){
          var snapshot = NSDiffableDataSourceSnapshot<LibObject , LibItem>()
          let section = self.section
  
          snapshot.appendSections(section)
  
          for section in section {
              snapshot.appendItems(section.items!, toSection: section)
          }
  
          datasource?.apply(snapshot)
      }
    
    func createDataSource() {
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem> (collectionView: collectionview, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let section = self.section[indexPath.section]

            switch(section.type){
            case "Tracks":
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: nil, CollectionCell.self, with: item, indexPath: indexPath)
            case "Artist":
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: self.navigationController, ArtistSection.self, with: item, indexPath: indexPath)
            default:
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: self.navigationController, MediumImageSlider.self, with: item, indexPath: indexPath)
            }
        })
        
        datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, IndexPath in
      
            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else { return nil}
            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil}
                
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
                print("could not dequeue supplementory view")
                return nil
            }
                
            sectionHeader.tagline.text = section.tagline
            sectionHeader.title.text = section.type
                
            return sectionHeader
                
        }
    }
    
} //Depricated

class TableSectionHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .secondaryLabel
        view.font = UIFont.boldSystemFont(ofSize: 17)
        return view
    }()
}
class AlbumFlowSection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "AlbumFlow"
    
    var data = [LibItem]()
    var vc: UINavigationController!
    
    var collectionview: UICollectionView! = nil

    func configure(data: [LibItem], navigationController: UINavigationController){
        
        self.data = data
        vc =  navigationController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 150, height: 190)
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(AlbumCover.self, forCellWithReuseIdentifier: AlbumCover.reuseIdentifier)
        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
        
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: AlbumCover.reuseIdentifier, for: indexPath) as! AlbumCover
        
        cell.configure(item: data[indexPath.row], navigationController: vc)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

}
class AlbumCover: UICollectionViewCell {
     
    static let reuseIdentifier: String = "albumCover"
    
    let image = UIImageView()
    let artist = UILabel()
    let title = UILabel()
    
    var vc: UINavigationController!
    var tapgesture: CustomGestureRecognizer!
    
    let container: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        artist.textColor = .secondaryLabel
        artist.translatesAutoresizingMaskIntoConstraints = false
        artist.setFont(with: 10)
        
        title.textColor = .label
        title.setFont(with: 12)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [title, artist])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 0
        
        addSubview(container)
        container.addSubview(image)
        container.addSubview(stackview)
        
        NSLayoutConstraint.activate([

            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150),
            
            stackview.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),

//            artist.topAnchor.constraint(equalTo: title.bottomAnchor, constant: -10),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(item: LibItem, navigationController: UINavigationController){
        image.setUpImage(url: item.imageURL)
        title.text = item.title
        artist.text = item.name
        
        tapgesture = CustomGestureRecognizer(target: self, action: #selector(didSelectAlbum(sender:)))
        tapgesture.id = item.id
        
        image.addGestureRecognizer(tapgesture)
        vc = navigationController
    }
    
    @objc func didSelectAlbum(sender: CustomGestureRecognizer){
     
        print("did tap image")
        let view = DetailViewController()
        view.albumId = sender.id!
        vc?.pushViewController(view, animated: true)
//        window?.rootViewController?.presentedViewController?.present(view, animated: true)
//        window?.rootViewController?.presentedViewController?.navigationController?.pushViewController(view, animated: true)
    }
}

class CollectionCell: UICollectionViewCell, Cell{
    
    static var reuseIdentifier: String = "Top Tracks"
    
    var tapGesture: CustomGestureRecognizer?
    
    let chartPosition = UILabel()
    let image = UIImageView()
    let title = UILabel()
    let artist = UILabel()
    let listenCount = UILabel()
    var track: Track!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        addGestureRecognizer(tapGesture!)
        
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        title.setFont(with: 12)
        
        artist.setFont(with: 10)
        artist.textColor = .secondaryLabel
        
        listenCount.setFont(with: 10)
        listenCount.textColor = .secondaryLabel
        listenCount.textAlignment = .right
        
        let innterStackview = UIStackView(arrangedSubviews: [title, artist])
        innterStackview.axis = .vertical
        innterStackview.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [image, innterStackview, listenCount] )
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fill
        stackview.spacing = 10
        
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            listenCount.leadingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: -50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {

        track = Track(id: item.id,
                      type: item.type!,
                      trackNum: nil,
                      title: item.title!,
                      artistId: item.artistId!,
                      name: item.name!,
                      imageURL: item.imageURL,
                      albumId: item.albumId!,
                      audioURL: item.audioURL!,
                      playCount: nil)
        
        chartPosition.text = "1"
        image.setUpImage(url: item.imageURL)
        title.text = item.title
        artist.text = item.name
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: item.playCount!), number: .decimal)
        
        tapGesture?.id = item.id
        
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        AudioManager.shared.initPlayer(track: track, tracks: nil)
    }
}

class TrackStrip: UITableViewCell, TableCell{
    
    static var reuseIdentifier: String = "track"
    
    var image = UIImageView()
    var artist = UILabel()
    var name = UILabel()
    let options = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        image.contentMode = .scaleAspectFill
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backgroundColor = .clear
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        
        name.textColor = .label
        name.font = UIFont.systemFont(ofSize: 12)
        
        artist.textColor = .secondaryLabel
        artist.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        options.translatesAutoresizingMaskIntoConstraints = false
        options.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        options.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)

        
        let labelStack = UIStackView(arrangedSubviews: [name, artist])
        labelStack.axis = .vertical
        
        let horizontalStack = UIStackView(arrangedSubviews: [image, labelStack, options])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10

        
        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            image.leadingAnchor.constraint(equalTo: options.trailingAnchor, constant: 7),
            
            options.widthAnchor.constraint(equalToConstant: 30 ),
            options.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalStack.widthAnchor.constraint(equalToConstant: bounds.width - 40),
            
            horizontalStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    func configure(track: Track){
        
        image.setUpImage(url: track.imageURL)
        name.text = track.title
        artist.text = track.name
        
    }
    
    func configureWithSet(image: String, name: String, artist: String, type: String) {

        self.image.setUpImage(url: image)
        self.name.text = "\(type) • \(name)"
        self.artist.text = artist
        
    }
   
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
class TrackWithPlayCount: UITableViewCell {
    static let reuseIdentifier: String = "Trending"
    
//    var vc: UINavigationController?
//    var tapGesture: CustomGestureRecognizer?
    
    let chartPosition = UILabel()
    let image = UIImageView()
    let title = UILabel()
    let artist = UILabel()
    let listenCount = UILabel()
//    var track: Track!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
//        addGestureRecognizer(tapGesture!)
        
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
//        image.layer.cornerRadius = 10
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        title.setFont(with: 12)
        
        artist.setFont(with: 10)
        artist.textColor = .secondaryLabel
        
        listenCount.setFont(with: 10)
        listenCount.textColor = .secondaryLabel
        listenCount.textAlignment = .right
//        listenCount.numberOfLines = 0
        listenCount.translatesAutoresizingMaskIntoConstraints = false
        listenCount.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        chartPosition.setFont(with: 10)
        chartPosition.textColor = .secondaryLabel
        
        let innterStackview = UIStackView(arrangedSubviews: [title, artist])
        innterStackview.axis = .vertical
        innterStackview.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [image, innterStackview, listenCount] )
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillProportionally
        stackview.spacing = 10
        
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        
            listenCount.leadingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: -38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem) {
        
//        vc = rootVc!
        
//        track = Track(id: catalog.id, title: catalog.title!, artistId: catalog.artistId!, name: catalog.name!, imageURL: catalog.imageURL, albumId: catalog.albumId!, audioURL: catalog.audioURL)
//
//        tapGesture?.track = track
        
        image.setUpImage(url: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: catalog.playCount!), number: .decimal)
        
    
    }
    
//    func didTap(_sender: CustomGestureRecognizer) {
//        AudioManager.shared.initPlayer(track: track, tracks: nil)
//    }
}
class AviTableCell: UITableViewCell, TableCell{
    
    static var reuseIdentifier: String = "AviCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        let labelStack = UIStackView(arrangedSubviews: [artist])
        labelStack.axis = .vertical
        
        let horizontalStack = UIStackView(arrangedSubviews: [image, labelStack, options])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10
        
        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            
            image.leadingAnchor.constraint(equalTo: options.trailingAnchor, constant: 7),
            
            options.widthAnchor.constraint(equalToConstant: 30 ),
            options.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            horizontalStack.widthAnchor.constraint(equalToConstant: bounds.width - 40),
            
            horizontalStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configureWithSet(image: String, name: String, artist: String, type: String) {
        self.image.setUpImage(url: image)
        self.artist.text = "\(type) • \(artist)"
    }
    
    let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.contentMode = .scaleAspectFill
//        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.clipsToBounds = true
//        image.layer.cornerRadius = 5
        return image
    }()
    
    var artist: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 12)
        return label
    }()
    var name: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 12)
        
        return label
    }()
    let options: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        return btn
    }()
}
class SettingsCell: UITableViewCell {
    static let identifier = "settingCell"
    
    let container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        return view
    }()
    
    let settingImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        return view
    }()
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.setFont(with: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let settingsDescription: UILabel = {
        let label = UILabel()
        label.setFont(with: 10)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(with image: String, settinglabel: String, description: String){
        
        settingsLabel.text = settinglabel
        settingsDescription.text = description
        settingImage.image = UIImage(systemName: image)
        settingImage.contentMode = .scaleAspectFit
        
        let labelStack = UIStackView(arrangedSubviews: [settingsLabel, settingsDescription])
        labelStack.axis = .vertical
        labelStack.distribution = .equalSpacing

        print(settinglabel)

        let containerStack = UIStackView(arrangedSubviews: [settingImage, labelStack])
        containerStack.axis = .horizontal
        containerStack.distribution = .equalSpacing
        containerStack.spacing = 20
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(container)
        container.addSubview(containerStack)
        
        NSLayoutConstraint.activate( [
            
            settingImage.widthAnchor.constraint(equalToConstant: 30),
            containerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            containerStack.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
    }
    
}
