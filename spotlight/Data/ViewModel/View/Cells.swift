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
    
    let tagline = UILabel()
    let image = UIImageView()
    let title = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        
        title.font = UIFont.boldSystemFont(ofSize: 20)
        
        let stackview = UIStackView(arrangedSubviews: [image])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
        
        stackview.axis = .vertical
        stackview.spacing = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        self.NavVc = rootVc
        
        image.image = UIImage(named: catalog.imageURL)
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapGesture.id = catalog.albumId
        image.addGestureRecognizer(tapGesture)
        
        title.text = catalog.title
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = OverViewController()
        view.albumId = _sender.id
        
        print("presenting...")
        NavVc!.title = "Featured"
        NavVc!.pushViewController(view, animated: true)
        
    }
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
        image.layer.cornerRadius = 10
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
        let track = Track(Id: catalog.id, Title: catalog.title!, ArtistId: catalog.artistId!, Artists: catalog.name!, Image: catalog.imageURL, AlbumId: catalog.albumId!, audioURL: catalog.audioURL)
        
        tapGesture?.track = track
        
        chartPosition.text = String(indexPath! + 1)
        image.image = UIImage(named: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: catalog.playCount!), number: .decimal)
        
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: self, userInfo: ["track" : _sender.track!])

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
        image.layer.cornerRadius = 10
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
        
        image.image = UIImage(named: catalog.imageURL)
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
        image.layer.cornerRadius = 10
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
        
        image.image = UIImage(named: catalog.imageURL)
        title.text = catalog.title
        artist.text = catalog.name
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        print("History Track")
    }
}
class PlayerContainerSection: UICollectionViewCell, PlayerConfiguration{
    
    static let reuseIdentifier: String = "TrackPlayer"
    var backgroundImg: UIImageView?
        
    let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 500, height: contentView.frame.height))
        backgroundImg?.contentMode = .scaleAspectFill
        
        contentView.addSubview(backgroundImg!)
        contentView.addSubview(container)
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with player: Queue, rootVc: UINavigationController?) {
        backgroundImg?.image = UIImage(named: "6lack")
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
    let trackPrice = UILabel()
    
    
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
        image.layer.cornerRadius = 5
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        self.addGestureRecognizer(tapGesture!)
        
//        backgroundColor = .red
        name.textColor = .label
        name.setFont(with: 12)
        
        artist.textColor = .secondaryLabel
        artist.setFont(with: 10)
        
        trackPrice.translatesAutoresizingMaskIntoConstraints = false
        trackPrice.setFont(with: 10)
        trackPrice.textColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)

        
        let labelStack = UIStackView(arrangedSubviews: [name, artist])
        labelStack.axis = .vertical
        
        let horizontalStack = UIStackView(arrangedSubviews: [image, labelStack, trackPrice])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        
        horizontalStack.spacing = 10

        
        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            image.leadingAnchor.constraint(equalTo: trackPrice.trailingAnchor, constant: 7),
            
            trackPrice.widthAnchor.constraint(equalToConstant: 30 ),
//            trackPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
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
        vc = rootVc!
        image.image = UIImage(named: item.imageURL)
        name.text = item.title
        artist.text = item.name
        trackPrice.text = "$0.99"
        
        let track = Track(Id: item.id, Title: item.title!, ArtistId: item.artistId!, Artists: item.name!, Image: item.imageURL, AlbumId: item.albumId!, audioURL: item.audioURL)
        
        tapGesture?.track = track
    }
    @objc func didTap(_sender: CustomGestureRecognizer){
//        print("Sender: ", _sender.track)
        
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track": _sender.track!])
    }
    
}

// headers
class DetailHeader: UICollectionReusableView, GestureAction{
    
    static let reuseableIdentifier: String = "image Header"
    
    var vc: UINavigationController?
    var tapGesture: CustomGestureRecognizer?
    
    var artistId = String()
    
    // labels
    let title = UILabel() // Title
    let artist = UILabel() //
    let pageTag = UILabel()
    let datePublished = UILabel()
    
    // Images
    let imageContainer = UIView()
    let imageLayer = UIView()
    let image = UIImageView()
    let artistAviImage = UIImageView()
    
    // buttons
    let playBtn = UIButton()
    let shuffleBtn = UIButton()
    let buyBtn = UIButton()
    let priceLabel = UIButton()
    let optionsBtn = UIButton()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .quaternaryLabel
        
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
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.clipsToBounds = true
        imageContainer.layer.cornerRadius = 10
        imageContainer.backgroundColor = .red
        imageContainer.addSubview(image)
//        imageContainer.addSubview(imageLayer)
        
//        playBtn.setTitle("Play All", for: .normal)
//        let btnImage = UIImage(systemName: "play.circle.fill")?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        
//        playBtn.setImage(btnImage, for: .normal)
//        playBtn.layer.borderWidth = 1
//        playBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
////        playBtn.layer.cornerRadius = 5
//        playBtn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
//        
//        playBtn.titleLabel?.setFont(with: 50)
//        playBtn.translatesAutoresizingMaskIntoConstraints = false
////        
//        imageLayer.backgroundColor = .red
//        imageLayer.layer.zPosition = 2
//        imageLayer.translatesAutoresizingMaskIntoConstraints = false
//        imageLayer.addSubview(playBtn)
//
        // btns
        buyBtn.setTitle("Buy | $9.99", for: .normal)
        buyBtn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        buyBtn.titleLabel?.setFont(with: 10)
        buyBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        buyBtn.layer.borderWidth = 1
        buyBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        buyBtn.layer.cornerRadius = 5
        buyBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBtn.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        priceLabel.setTitle(" $9.99", for: .normal)
        priceLabel.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        priceLabel.titleLabel?.setFont(with: 10)
        priceLabel.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        shuffleBtn.setTitle("Shuffle", for: .normal)
        shuffleBtn.layer.borderWidth = 1
        shuffleBtn.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5).cgColor
        shuffleBtn.layer.cornerRadius = 3
        shuffleBtn.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5), for: .normal)
        shuffleBtn.titleLabel?.setFont(with: 15)
        
        pageTag.textColor = .secondaryLabel
        
        datePublished.text = "Published 2019, 10 Tracks ,45 minutes"
        datePublished.setFont(with: 12)
        datePublished.textColor = .secondaryLabel
        
        
        let btnStack = UIStackView(arrangedSubviews: [pageTag])
        btnStack.axis = .horizontal
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.distribution = .fillEqually
        
        let TirtiaryStack = UIStackView(arrangedSubviews: [pageTag, btnStack])
        TirtiaryStack.axis = .horizontal
        TirtiaryStack.translatesAutoresizingMaskIntoConstraints = false
        TirtiaryStack.distribution = .equalSpacing
        
        let SecondaryStack = UIStackView(arrangedSubviews: [artistAviImage, artist, buyBtn])
        SecondaryStack.axis = .horizontal
        SecondaryStack.alignment = .center
        SecondaryStack.distribution = .fill
        SecondaryStack.spacing = 10
        
//        let playBtnStack = UIStackView(arrangedSubviews: [,huffleBtn])
//        playBtnStack.alignment = .center
//        playBtnStack.axis = .horizontal
//        playBtnStack.distribution = .fillProportionally
//        playBtnStack.spacing = 10
        
        let ContainerStack = UIStackView(arrangedSubviews: [imageContainer, title, SecondaryStack, datePublished, seperator, TirtiaryStack ])
        ContainerStack.translatesAutoresizingMaskIntoConstraints = false
        ContainerStack.axis = .vertical
        ContainerStack.spacing = 17
        
        
//        addSubview(imageContainer)
        
        addSubview(ContainerStack)
        
        NSLayoutConstraint.activate([
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            imageContainer.heightAnchor.constraint(equalToConstant: 355),
            imageContainer.widthAnchor.constraint(equalToConstant: 350),
//
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//
            image.heightAnchor.constraint(equalTo: imageContainer.heightAnchor),
            image.widthAnchor.constraint(equalTo: imageContainer.widthAnchor),
//
//            imageLayer.heightAnchor.constraint(equalTo: imageContainer.heightAnchor),
//            imageLayer.widthAnchor.constraint(equalTo: imageContainer.widthAnchor),
//
            artistAviImage.heightAnchor.constraint(equalToConstant: 40),
            artistAviImage.widthAnchor.constraint(equalToConstant: 40),
//            
//            playBtn.leadingAnchor.constraint(equalTo: imageLayer.leadingAnchor, constant: 20),
//            playBtn.bottomAnchor.constraint(equalTo: imageLayer.bottomAnchor, constant: -20),
//            
            ContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            ContainerStack.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 20),
//            ContainerStack.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            
            btnStack.trailingAnchor.constraint(equalTo: ContainerStack.trailingAnchor)
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
        
        let track = Track(Id: item.id, Title: item.title!, ArtistId: item.artistId!, Artists: item.name!, Image: item.imageURL, AlbumId: item.albumId!, audioURL: item.audioURL)
        
        tapGesture?.track = track
        
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name("trackChange"), object: nil, userInfo: ["track": _sender.track!])
    }
}
