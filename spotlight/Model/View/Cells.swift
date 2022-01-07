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
       
        tapGesture.id = catalog.albumId
        
        title.text = catalog.title
        
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = OverViewController()
        view.albumId = _sender.id
        
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
        let view = Profile()
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
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        addGestureRecognizer(tapGesture!)
        
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
        listenCount.numberOfLines = 0
        listenCount.layer.borderColor = UIColor.red.cgColor
        listenCount.layer.borderWidth = 1
        listenCount.translatesAutoresizingMaskIntoConstraints = false
        listenCount.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        chartPosition.setFont(with: 10)
        chartPosition.textColor = .secondaryLabel
        
        let innterStackview = UIStackView(arrangedSubviews: [title, artist])
        innterStackview.axis = .vertical
        innterStackview.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [chartPosition, image, innterStackview] )
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
            
            chartPosition.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -20),
            chartPosition.widthAnchor.constraint(equalToConstant: 5),
        
//            listenCount.leadingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: -38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        vc = rootVc!
        
        let track = Track(id: catalog.id, title: catalog.title!, artistId: catalog.artistId!, name: catalog.name!, imageURL: catalog.imageURL, albumId: catalog.albumId!, audioURL: catalog.audioURL)
        
        tapGesture?.track = track
        
        chartPosition.text = String(indexPath! + 1)
        image.setUpImage(url: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: catalog.playCount!), number: .decimal)
        
    
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track" : _sender.track! as Track])

    }
}
class MediumImageSlider: UICollectionViewCell, Cell{
    
    static let reuseIdentifier: String = "MediumSlider"
    
    var vc: UINavigationController?
    var tapgesture: CustomGestureRecognizer?
    
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
        
        tapgesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapgesture!.id = catalog.id
        
        addGestureRecognizer(tapgesture!)
        
        image.setUpImage(url: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
    }
    
    func didTap(_sender: CustomGestureRecognizer) {

        print(_sender.id!)
        let view = OverViewController()
        view.albumId = _sender.id

        vc?.pushViewController(view, animated: true)
        
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

// Track Overview Cells
class TrackDetailStrip: UICollectionViewCell, Cell{
    static var reuseIdentifier: String = "track"
    
    var tapGesture: CustomGestureRecognizer?
    var vc: UINavigationController?
    
    var image = UIImageView()
    var artist = UILabel()
    var name = UILabel()
    let optionsBtn = UIButton()
    
    
    let view: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.contentMode = .scaleAspectFill
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.clipsToBounds = true
//        image.layer.cornerRadius = 5
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        self.addGestureRecognizer(tapGesture!)
        
//        backgroundColor = .red
        name.textColor = .label
        name.setFont(with: 12)
        
        artist.textColor = .secondaryLabel
        artist.setFont(with: 10)
        
        optionsBtn.translatesAutoresizingMaskIntoConstraints = false
        optionsBtn.tintColor = .secondaryLabel
        
        optionsBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)

        
        let labelStack = UIStackView(arrangedSubviews: [name, artist])
        labelStack.axis = .vertical
        
        let horizontalStack = UIStackView(arrangedSubviews: [image, labelStack, optionsBtn])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        
        horizontalStack.spacing = 10

        
        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            image.leadingAnchor.constraint(equalTo: optionsBtn.trailingAnchor, constant: 7),
            
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
        
//        let index = Int(indexPath!) + 1
//        vc = rootVc!
        image.setUpImage(url: item.imageURL)
        name.text = item.title
        artist.text = item.name
        
        tapGesture!.track = Track(id: item.id, title: item.title!, artistId: item.artistId!, name: item.name!, imageURL: item.imageURL, albumId: item.albumId!, audioURL: item.audioURL!)
    }
    @objc func didTap(_sender: CustomGestureRecognizer){
//        print("Sender: ", _sender.track)
        
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track" : _sender.track! as Track])
    }
    
}

// headers
class DetailHeader: UICollectionReusableView, GestureAction{
    
    static let reuseableIdentifier: String = "image Header"
    
    var tracks = [Track]()
    var vc: UINavigationController?
    var tapGesture: CustomGestureRecognizer?
    var artistId = String()
    
    // labels
    let title = UILabel() // Title
    let artist = UILabel() //
    let pageTag = UILabel()
    let datePublished = UILabel()
    
    // Images
    let imageContainer = UIImageView()
    let imageLayer = UIView()
    let image = UIImageView()
    let artistAviImage = UIImageView()
    
    // buttons
    var playBtn: UIButton!
    let shuffleBtn = UIButton()
    let buyBtn = UIButton()
    let priceLabel = UIButton()
    let optionsBtn = UIButton()
    let container = UIView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .quaternaryLabel
        
        setupGradient()
        
        title.textColor = .white
        title.setFont(with: 25)
        title.numberOfLines = 0

        artist.textColor = .label
        artist.setFont(with: 15)
        artist.translatesAutoresizingMaskIntoConstraints = false

        artistAviImage.layer.borderWidth = 1
        artistAviImage.contentMode = .scaleAspectFill
        artistAviImage.translatesAutoresizingMaskIntoConstraints = false
        artistAviImage.clipsToBounds = true
        artistAviImage.layer.cornerRadius = 20
        artistAviImage.isUserInteractionEnabled = true

        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        artistAviImage.addGestureRecognizer(tapGesture!)

        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false
//
        let btnConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let btnImage = UIImage(systemName: "play", withConfiguration: btnConfig)

        let shuffleConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let shuffleImg = UIImage(systemName: "shuffle", withConfiguration: shuffleConfig)



        playBtn = UIButton()
        playBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        playBtn.setImage(btnImage, for: .normal)
        playBtn.setTitle("Play", for: .normal)
        playBtn.layer.borderWidth = 1
        playBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        playBtn.layer.cornerRadius = 5

        playBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        playBtn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)

        playBtn.titleLabel?.setFont(with: 20)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.layer.zPosition = 2
        playBtn.addTarget(self, action: #selector(playAllTracks), for: .touchUpInside)
        playBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

        shuffleBtn.setTitle("Shuffle", for: .normal)
        shuffleBtn.layer.borderWidth = 1
        shuffleBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        shuffleBtn.layer.cornerRadius = 5
        shuffleBtn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        shuffleBtn.titleLabel?.setFont(with: 20)
        shuffleBtn.setImage(shuffleImg, for: .normal)
        shuffleBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        shuffleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)

        pageTag.textColor = .secondaryLabel

        datePublished.text = "Published 2019, 10 Tracks ,45 minutes"
        datePublished.setFont(with: 12)
        datePublished.textColor = .secondaryLabel

        let btnStack = UIStackView(arrangedSubviews: [playBtn,shuffleBtn])
        btnStack.axis = .horizontal
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.distribution = .fillEqually
        btnStack.spacing = 10

        let TirtiaryStack = UIStackView(arrangedSubviews: [pageTag])
        TirtiaryStack.axis = .horizontal
        TirtiaryStack.translatesAutoresizingMaskIntoConstraints = false
        TirtiaryStack.distribution = .equalSpacing
        
        let SecondaryStack = UIStackView(arrangedSubviews: [artistAviImage, artist])
        SecondaryStack.axis = .horizontal
        SecondaryStack.alignment = .center
        SecondaryStack.distribution = .fill
        SecondaryStack.spacing = 10
//
//        let playBtnStack = UIStackView(arrangedSubviews: [playBtn,shuffleBtn])
//        playBtnStack.alignment = .center
//        playBtnStack.axis = .horizontal
//        playBtnStack.distribution = .fillProportionally
//        playBtnStack.spacing = 10
//
        
        addSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
       
        
//        let ContainerStack = UIStackView(arrangedSubviews: [image ])
        let ContainerStack = UIStackView(arrangedSubviews: [image, btnStack, title, SecondaryStack, datePublished, seperator, TirtiaryStack])
         
//        let ContainerStack = UIStackView(arrangedSubviews: [image])
        ContainerStack.translatesAutoresizingMaskIntoConstraints = false
        ContainerStack.axis = .vertical
        ContainerStack.spacing = 17
        
        
//        imageContainer.backgroundColor = .red
        
        container.addSubview(ContainerStack)

        
        
        
        
        NSLayoutConstraint.activate([
//            seperator.heightAnchor.constraint(equalToConstant: 1),

//            imageContainer.heightAnchor.constraint(equalToConstant: 200),r
//            imageContainer.widthAnchor.constraint(equalToConstant: 200),
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -100),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
            imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: -48),
            imageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
////
            container.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            container.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
            image.heightAnchor.constraint(equalToConstant: 355),
            image.widthAnchor.constraint(equalToConstant:350),

            artistAviImage.heightAnchor.constraint(equalToConstant: 40),
            artistAviImage.widthAnchor.constraint(equalToConstant: 40),

            ContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ContainerStack.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 75),
            ContainerStack.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
//
            btnStack.trailingAnchor.constraint(equalTo: ContainerStack.trailingAnchor),
//            optionsBtn.trailingAnchor.constraint(equalTo: ContainerStack.trailingAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = Profile()
        view.artistId = artistId
        
        vc?.pushViewController(view, animated: true)
    }

    @objc func playAllTracks(){
        
        AudioManager.initPlayer(track: nil, tracks: tracks)
    }
    
    func setupGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1).cgColor]
        gradientLayer.locations = [0.2, 1.3]
        
        gradientLayer.frame = frame
        
        let blurEffect = UIBlurEffect(style: .regular)
       let visualEffectView = UIVisualEffectView(effect: blurEffect)
       
        container.layer.addSublayer(gradientLayer)
        container.frame = imageContainer.frame
        
        addSubview(container)
        container.addSubview(visualEffectView)
        visualEffectView.frame = frame
//        container.backgroundColor = .red
        container.layer.zPosition = 2
        container.layer.addSublayer(gradientLayer)
        
//        let stack = UIStackView(arrangedSubviews: [name, verifiedIcon ])
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.spacing = 10
//
//        let containerStack = UIStackView(arrangedSubviews: [stack, followBtn, listener ])
//        containerStack.axis = .vertical
//        containerStack.alignment = .leading
//        containerStack.spacing = 7
//        containerStack.translatesAutoresizingMaskIntoConstraints = false
//
//
//        container.addSubview(containerStack)
//
//        containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
//        containerStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

    }
    
}
class SectionHeader: UICollectionReusableView, GestureAction {
  
    static let reuseIdentifier: String = "sectionHeader"
    
    let title = UILabel()
    let tagline = UILabel()
    let moreBtn = UIButton()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .quaternaryLabel
        
        title.textColor = .label
        title.setFont(with: 10)
        title.textColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        
        tagline.textColor = .secondaryLabel
        tagline.font = UIFont.boldSystemFont(ofSize: 17)
        
        
//        moreBtn.setTitle("more", for: .normal)
        moreBtn.titleLabel?.setFont(with: 10)
        moreBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        let hstack = UIStackView(arrangedSubviews: [tagline, moreBtn ])
        hstack.axis = .horizontal
        hstack.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [title, hstack, seperator])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
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
  
    static var reuseIdentifier: String =  "profile Header"
    
    var image = UIImageView()
    var name = UILabel()
    var artistAvi = UIImageView()
    
    let followBtn = UIButton()
    let optionsBtn = UIButton()
    let verifiedIcon = UIButton()
    
    let listener = UILabel()

    let container = UIView(frame: .zero)
    
    var stack = UIStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
//        let seperator = UIView(frame: .zero)
//        seperator.backgroundColor = .quaternaryLabel
//
        name.setFont(with: 30)
        name.translatesAutoresizingMaskIntoConstraints = false

        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
        addSubview(image)
        
        image.topAnchor.constraint(equalTo: topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
         
        followBtn.setTitle("Follow", for:  .normal)
        followBtn.titleLabel!.setFont(with: 12)
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        followBtn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        followBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followBtn.layer.cornerRadius = 5

        optionsBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)

        verifiedIcon.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
        verifiedIcon.titleLabel?.setFont(with: 5)
        
        listener.textColor = .secondaryLabel
        listener.setFont(with: 10)
        
        self.stack = UIStackView(arrangedSubviews: [name, followBtn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
    
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {

        name.text = item.name!
        let listnersCount = NumberFormatter.localizedString(from: NSNumber(value: item.listeners!), number: NumberFormatter.Style.decimal)
        listener.text = "Listeners: \(listnersCount)"

        image.image = UIImage(named: item.imageURL)

        setupGradient()
    }
//
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

        let containerStack = UIStackView(arrangedSubviews: [stack, followBtn, listener ])
        containerStack.axis = .vertical
        containerStack.alignment = .leading
        containerStack.spacing = 7
        containerStack.translatesAutoresizingMaskIntoConstraints = false
    
        
        container.addSubview(containerStack)
        
        containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
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

        chartPosition.text = "1"
        image.image = UIImage(named: item.imageURL)
        title.text = item.title
        artist.text = item.name
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: item.playCount!), number: .decimal)
        
        tapGesture?.id = item.id
        
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track": _sender.id!])
    }
}

class TrackStrip: UITableViewCell{
    static var reuseIdentifier: String = "track"
    
    var image = UIImageView()
    var artist = UILabel()
    var name = UILabel()
    let options = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        image.contentMode = .scaleAspectFill
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backgroundColor = .clear
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        
        name.textColor = .label
        name.setFont(with: 12)
        
        artist.textColor = .secondaryLabel
        artist.setFont(with: 10)
        
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
        
        image.image = UIImage(named: track.imageURL)
        name.text = track.title
        artist.text = track.name
        
//        tapGesture!.track = Track(id: item.id, title: item.title!, artistId: item.artistId!, name: item.name!, imageURL: item.imageURL, albumId: item.albumId!, audioURL: item.audioURL!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
//    @objc func didTap(_sender: CustomGestureRecognizer){
////        print("Sender: ", _sender.track)
//
//        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track" : _sender.track! as Track])
//    }
    
}

// Settings
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
