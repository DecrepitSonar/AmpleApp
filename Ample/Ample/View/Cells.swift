//
//  CollectionViewCells.swift
//  spotlight
//
//  Created by Robert Aubow on 8/14/21.
//

import Foundation
import UIKit
import AVFoundation

class FeaturedHeader: UICollectionViewCell, Cell{

    static var reuseIdentifier: String = "Featured Header"
    var tapGesture = CustomGestureRecognizer()
    var NavVc: UINavigationController?
    let blurrEffect = UIBlurEffect(style: .light)
    var contentType: String!
    var vc: UIViewController!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        let visualEffect = UIVisualEffectView(effect: blurrEffect)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        
        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .tertiaryLabel
        
        let labelStack = UIStackView(arrangedSubviews: [type, title, tagline])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 2
        
        let stackview = UIStackView(arrangedSubviews: [ seperator,labelStack, image ])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = 10
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        
        contentView.addSubview(stackview )
        addSubview(itemContainer)

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            image.heightAnchor.constraint(equalToConstant: 200),
            
            seperator.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            seperator.heightAnchor.constraint(equalToConstant: 0.5)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        self.NavVc = rootVc
        image.setUpImage(url: catalog.posterImage!, interactable: true)
        featuredTrackImage.setUpImage(url: catalog.imageURL!, interactable: true)
        
        image.addGestureRecognizer(tapGesture)

        contentType = catalog.type!
        type.text = catalog.type
        title.text = catalog.title
        tagline.text = catalog.tagline
        tapGesture.id = catalog.id
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
        print( contentType)
        
        let selectedItemId = _sender.id
        
        switch( contentType! ){
        case "Channel":
            let view = channelPageViewController()
            view.channelId = selectedItemId
            vc = view
        
        case "Artist":
            let view = ProfileViewController()
            view.id = selectedItemId!
            vc = view
        
        case "Single":
            let view = TrackViewController()
            view.trackId = selectedItemId!
            vc = view
            
            default:
                return
        }
//        print("presenting...")
//        NavVc!.title = "Featured"
        NavVc!.pushViewController(vc, animated: true)
        
    } 
//
//    let tagline: UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//        label.setFont(with: 20)
//        return label
//    }()
    let image: UIImageView = {
        
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 5
        
        return image
    }()

    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        label.setFont(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagline: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 17)
//        label.text = "Checkout this new thign that just dropped"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let artistName: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let featuredTrackImage: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 2
        return view
    }()
    let itemContainer: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    
}
class LargePlaylistCover: UICollectionViewCell, Cell{
    static var reuseIdentifier: String = "PlaylistCover"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: bounds.height),
            image.widthAnchor.constraint(equalToConstant: bounds.width)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboard ")
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        image.setUpImage(url: item.imageURL!, interactable: true)
        print(item.imageURL)
    
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        return image
        
    }()
    
}
class FeaturedVideoHeader: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    var player: AVPlayer!
    private var selectedVideo: Int = 0
    private var playerLayer: AVPlayerLayer!
    private var videoObject: VideoItemModel!
    private var playerItem: AVPlayerItem!
    private var asset: AVAsset!
    private var gesture: CustomGestureRecognizer!
    private var NVC: UINavigationController!
    private var data: [VideoItemModel]!
    private var collectionview: UICollectionView!
    private var isMuted: Bool = true
    private var playerItemContext = 0
    private var timeObserverToken: Any?
    
    let requiredAssetKeys = [
        "playable",
        "hasProtectedContent"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(container)
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 200)
        playerLayer.videoGravity = .resizeAspectFill
        container.layer.addSublayer(playerLayer)
    
        let labelStack = UIStackView(arrangedSubviews: [artistName, title])
        labelStack.axis = .vertical
        labelStack.distribution = .fillProportionally
        labelStack.translatesAutoresizingMaskIntoConstraints = false
              
        videoOverlay.addSubview(labelStack)
        videoOverlay.addSubview(muteBtn)
        videoOverlay.addSubview(expandVideoButton)
        videoOverlay.layer.zPosition = 3
        
        container.addSubview(videoOverlay)
        progressView.progress = 0
        progressView.layer.zPosition = 5
        container.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 200),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            
            videoOverlay.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            videoOverlay.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            videoOverlay.topAnchor.constraint(equalTo: container.topAnchor),
            videoOverlay.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            labelStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            labelStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),

            muteBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            muteBtn.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            
            expandVideoButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            expandVideoButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 5),
            progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 1),
        ])

        
        configureCollectionView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("no storyboard")
    }
    
    func initialize(data: [VideoItemModel], navigationController: UINavigationController){
//
        self.data = data

        title.text = data[selectedVideo].title
        artistName.text = data[selectedVideo].artist

        NVC = navigationController

        gesture = CustomGestureRecognizer(target: self, action: #selector(toggleOverlay))

        gesture.video = data[selectedVideo]
        container.addGestureRecognizer(gesture)
        
        setTrack()
    }
    
    override func layoutSubviews() {
        
        NotificationCenter.default.post(name: NSNotification.Name("videoSelected"), object: nil, userInfo: ["video" : data[self.selectedVideo]])
        print("setting")
        videoObject = data[selectedVideo]
    }
    
    func configureCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 100)
        
        collectionview = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(MiniVideoCollection.self, forCellWithReuseIdentifier: MiniVideoCollection.reuseIdentifier)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
    
        addSubview(collectionview)

        NSLayoutConstraint.activate([
            collectionview.heightAnchor.constraint(equalToConstant: 100),

            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    func removePeriodicTimeObserver(){
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            print( "removed time observer")
            timeObserverToken = nil
        }
    }
    func addPeriodicTimeObserver(){
        
        let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_MSEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main) { time in
            
            print(Float(CMTimeGetSeconds(self.player.currentTime())  / CMTimeGetSeconds(self.playerItem.duration )))
            
            self.progressView.setProgress(Float(CMTimeGetSeconds(self.player.currentTime())  / CMTimeGetSeconds(self.playerItem.duration )), animated: true)
        
        }
        
    }
    func addBoundaryTimeObserver(){
        let totalTrackTime = NSValue(time: CMTime(value: playerItem.duration.value, timescale: CMTimeScale(NSEC_PER_SEC)))
        let time = [totalTrackTime]
        
        player.addBoundaryTimeObserver(forTimes: time, queue: DispatchQueue.main) {
            print("Track ended")
        }
        
    }
    func setTrack() {
        
        removePeriodicTimeObserver()
        
        NotificationCenter.default.post(name: NSNotification.Name("videoSelected"), object: nil, userInfo: ["video" : data[self.selectedVideo]])
        print("setting")
        
        progressView.setProgress(0.0, animated: true)
        
        let videoURL = URL(string: data[selectedVideo].videoURL)
        
        playerItem = AVPlayerItem(url: videoURL!)
        
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        
        player.replaceCurrentItem(with: playerItem)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                print("Ready to play")
                player.isMuted = isMuted
                player.play()
                
                title.text = data[selectedVideo].title
                artistName.text = data[selectedVideo].artist
                
                addPeriodicTimeObserver()
                
            case .failed:
                // Player item failed. See error.
                print("Failed to play video ")
                
                print(player.error)
            case .unknown:
                // Player item is not yet ready.
                print("Player encountered an unknown error ")
            }
        }
    }
    
    @objc func toggleOverlay(){
        if videoOverlay.isHidden {
            videoOverlay.isHidden = false
        }
        else{
            videoOverlay.isHidden = true
        }
    }
    @objc func expandVideo(){
        
        let videoView = VideoViewController()
        videoView.selectedVideo = videoObject.id
        videoView.modalPresentationStyle = .overFullScreen
        videoView.modalTransitionStyle = .coverVertical
        
        player.rate = 0
        NVC.present( videoView, animated: true)
    }
    @objc func toggleMute(sender: UIButton){
        print("mute btn pressed")
        
        
        if(player.isMuted){
            player.isMuted = false
            isMuted = false
            DispatchQueue.main.async {
                self.muteBtn.setImage(UIImage(systemName: "speaker.wave.2.circle.fill"), for: .normal)
                self.muteBtn.setNeedsDisplay()
            }
        }else{
            player.isMuted = true
            isMuted = true
            
            DispatchQueue.main.async {
                self.muteBtn.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
                self.muteBtn.setNeedsDisplay()
            }
        }
    }
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let videoOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let muteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(toggleMute(sender:)), for: .touchUpInside)
        return btn
    }()
    let title: UILabel = {
        let label = UILabel()
        label.setFont(with: 20)
        label.textColor = .label
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.numberOfLines = 2
        return label
    }()
    let artistName: UILabel = {
        let label = UILabel()
        label.setBoldFont(with: 12)
        label.textColor = .label
        return label
    }()
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let expandVideoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "viewfinder"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(expandVideo), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: MiniVideoCollection.reuseIdentifier, for: indexPath) as! MiniVideoCollection
        cell.configureView(data: data![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        videoObject = data[indexPath.row]
        self.selectedVideo = indexPath.row
        
        setTrack()
        
        if indexPath.row > 0 && indexPath.row < data!.count - 1{
            collectionview.setContentOffset(CGPoint(x: 210 * indexPath.row , y: 0), animated: true)
        }
        
        else if (indexPath.row == 0 ){
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    
//        print("Seting up Artist")
        artistAvi.configureCard(img: catalog.imageURL!, name: catalog.name!)
//        print(catalog)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapGesture.id = catalog.id
        artistAvi.addGestureRecognizer(tapGesture)
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = ProfileViewController()
        view.id = _sender.id
        
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
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        title.setFont(with: 12)
        
        artist.setFont(with: 10)
        artist.textColor = .secondaryLabel
        
        listenCount.setFont(with: 10)
        listenCount.textColor = .secondaryLabel
        listenCount.textAlignment = .right
        listenCount.translatesAutoresizingMaskIntoConstraints = false
//        listenCount.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
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
            
            image.heightAnchor.constraint(equalToConstant: 35),
            image.widthAnchor.constraint(equalToConstant: 35),
            
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
        
            listenCount.leadingAnchor.constraint(equalTo: stackview.trailingAnchor, constant: -38)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        vc = rootVc!
        
        track = Track(id: catalog.id, title: catalog.title!, artistId: catalog.artistId!, name: catalog.name!, imageURL: catalog.imageURL!, albumId: catalog.albumId!, audioURL: catalog.audioURL)
        
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapGesture?.track = track
        self.addGestureRecognizer(tapGesture!)
        
        image.setUpImage(url: catalog.imageURL!, interactable: true)
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
        artist.setFont(with: 14)
        
        title.textColor = .label
        title.setFont(with: 14)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStack = UIStackView(arrangedSubviews: [title, artist])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .top
        labelStack.spacing = 0
        
        let stackview = UIStackView(arrangedSubviews: [image, labelStack])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 5
        
        addSubview(stackview)
        NSLayoutConstraint.activate([
            
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 165),
            image.widthAnchor.constraint(equalToConstant: 175),

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
        
        image.setUpImage(url: catalog.imageURL!, interactable: true)
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
        
        case "Track":
            let view = TrackViewController()
            view.trackId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        default:
            let view = AlbumViewController()
            view.albumId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        }
        
    }
}
class PlayList: UICollectionViewCell, Cell{
    
    static let reuseIdentifier: String = "playlistCell"
    
    var vc: UINavigationController?
    var tapgesture: CustomGestureRecognizer?
    var type: String?
    
    let image = UIImageView()
    let title = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        title.textColor = .label
        title.setFont(with: 15)
        title.translatesAutoresizingMaskIntoConstraints = false

        let stackview = UIStackView(arrangedSubviews: [image, title])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 5
        
        addSubview(stackview)
        NSLayoutConstraint.activate([
            
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 165),
            image.widthAnchor.constraint(equalToConstant: 175),

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
        
        image.setUpImage(url: catalog.imageURL!, interactable: true)
        title.text = catalog.title
    }
    
    func didTap(_sender: CustomGestureRecognizer) {

        
        switch( type){
        case "Playlist":
            let view = PlaylistViewController()
            view.id = _sender.id!
            vc?.pushViewController(view, animated: true)
        
        case "Track":
            let view = TrackViewController()
            view.trackId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        default:
            let view = AlbumViewController()
            view.albumId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        }
        
    }
}
class SmallImageSlider: UICollectionViewCell, Cell{
    
    static let reuseIdentifier: String = "smallSlider"
    
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
        artist.setFont(with: 15)
        
        title.textColor = .label
        title.setFont(with: 15)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStack = UIStackView(arrangedSubviews: [title, artist])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.distribution = .fill
        labelStack.alignment = .top
        labelStack.spacing = 0
        
        let stackview = UIStackView(arrangedSubviews: [image, labelStack])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 5
        
        addSubview(stackview)
        NSLayoutConstraint.activate([
            
            stackview.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackview.topAnchor.constraint(equalTo: topAnchor),
            stackview.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackview.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 120),
            image.widthAnchor.constraint(equalToConstant: 130),

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
        
        image.setUpImage(url: catalog.imageURL!, interactable: true)
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
        
        case "Track":
            let view = TrackViewController()
            view.trackId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        default:
            let view = AlbumViewController()
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
        
        image.setUpImage(url: catalog.imageURL!, interactable: true)
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
        image.setUpImage(url: item.imageURL!, interactable: true)
        artistLabel.text = item.name
        
        gesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        gesture.id = item.albumId
        
        self.vc = rootVc
        container.addGestureRecognizer(gesture)
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let profile = ProfileViewController()
        profile.id = _sender.id
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
class SmallVideoPoster: UICollectionViewCell, Cell {
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        artistLabel.text = item.artist
        title.text = item.title
//        viewCountLabel.text = "Views: \(String(item))"
        posterImage.setUpImage(url: item.imageURL!, interactable: false)
        
        self.video = item
        self.navigation = rootVc
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
    
    static var reuseIdentifier: String = "smallVideoPoster"
    
    var navigation: UINavigationController!
    var video: LibItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImage)
        let contentStack = UIStackView(arrangedSubviews: [title, artistLabel])
        contentStack.axis = .vertical
        contentStack.distribution = .fillProportionally
        contentStack.spacing = 5
//        contentStack.alignment = .leading
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalToConstant: 100),
            posterImage.widthAnchor.constraint(equalToConstant: 200),
            posterImage.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10)
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayVideoView)))
        
    }

    @objc func displayVideoView(){
        
        let videoView = VideoViewController()
        videoView.selectedVideo = video.id
        videoView.modalPresentationStyle = .overFullScreen
        videoView.modalTransitionStyle = .coverVertical
        
        navigation.present(videoView, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storboard provided")
    }
    
    func configure(with: VideoItemModel, navigationController: UINavigationController) {
    
      
    }
    
    let posterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.setFont(with: 15)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    let artistLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(with:  12 )
        label.textColor = .secondaryLabel
        return label
    }()
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.setFont(with: 10)
        label.textColor = .secondaryLabel
        return label
    }()
}
class SmallVideoPosterCell: UICollectionViewCell, Cell {
    
    static var reuseIdentifier: String = "smallVideoPostercell"
    
    var navigation: UINavigationController!
    var video: VideoItemModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(posterImage)
        let contentStack = UIStackView(arrangedSubviews: [title, artistLabel])
        contentStack.axis = .vertical
        contentStack.distribution = .fillProportionally
        contentStack.spacing = 5
        contentStack.alignment = .leading
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalToConstant: 100),
            posterImage.widthAnchor.constraint(equalToConstant: 200),
            posterImage.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10)
        ])
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(displayVideoView)))
        
    }

    @objc func displayVideoView(){
        
        let videoView = VideoViewController()
        videoView.selectedVideo = video.id
        videoView.modalPresentationStyle = .overFullScreen
        videoView.modalTransitionStyle = .coverVertical
        
        navigation.present(videoView, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storboard provided")
    }
    
    func configure(with: VideoItemModel, navigationController: UINavigationController) {
    
        artistLabel.text = with.artist
        title.text = with.title
        viewCountLabel.text = "Views: \(String(with.views))"
        posterImage.setUpImage(url: with.posterURL!, interactable: false)
        
        self.video = with
        self.navigation = navigationController
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        let video = VideoItemModel(id: item.id,
                                   videoURL: item.videoURL!,
                                   posterURL: item.posterURL,
                                   title: item.title!,
                                   artist: item.artist!,
                                   artistImageURL: nil,
                                   albumId: nil, views: 0)
        
        self.configure(with: video, navigationController: rootVc!)
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
    
    let posterImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.setFont(with: 15)
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    let artistLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(with:  12 )
        label.textColor = .secondaryLabel
        return label
    }()
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.setFont(with: 10)
        label.textColor = .secondaryLabel
        return label
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
        
        let horizontalStack = UIStackView(arrangedSubviews: [trackImage, labelStack, optionsBtn])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10

        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            trackImage.heightAnchor.constraint(equalToConstant: 50),
            trackImage.widthAnchor.constraint(equalToConstant: 50),
            trackImage.leadingAnchor.constraint(equalTo: optionsBtn.trailingAnchor, constant: 7),
            
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
        
        trackImage.setUpImage(url: item.imageURL!, interactable: true)
        trackTitleLabel.text = item.title
        artistNameLabel.text = item.name
        
        let track = Track(id: item.id,
                          title: item.title!,
                          artistId: item.artistId!,
                          name: item.name!,
                          imageURL: item.imageURL!,
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
    
    
}
class TrackCell: UITableViewCell{
    static var reuseIdentifier: String = "track"
    
    var tapGesture: CustomGestureRecognizer!
    var options: CustomGestureRecognizer!
    var user = UserDefaults.standard.value(forKey: "user")
    var isSaved: Bool = false
    var track: Track!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        options = CustomGestureRecognizer(target: self, action: #selector(openOptionsView(_sender:)))
        
        let labelStack = UIStackView(arrangedSubviews: [trackTitleLabel, artistNameLabel])
        labelStack.axis = .vertical
        
        selectionStyle = .none
        
        let horizontalStack = UIStackView(arrangedSubviews: [labelStack, videoButton, likedBtn])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 10

        addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with item: Track) {
        
        track = item
        
        trackImage.setUpImage(url: item.imageURL, interactable: true)
        trackTitleLabel.text = item.title
        artistNameLabel.text = item.name
        
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
        
        guard item.videoId == nil else {
            videoButton.isHidden = false
            return
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
    let videoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.tv"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        button.isHidden = true
        button.layer.zPosition = 2
        return button
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
class DetailHeader: UICollectionViewCell{
    
    static let reuseableIdentifier: String = "image Header"
    
    var tracks = [Track]()
    var track: Track!
    var type: String!
    
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

        playBtn.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        playBtn.isUserInteractionEnabled = true
        
//        setupGradient()/
        
        let btnStack = UIStackView(arrangedSubviews: [playBtn,shuffleBtn])
        btnStack.axis = .horizontal
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.distribution = .fillEqually
        btnStack.spacing = 10

        let TirtiaryStack = UIStackView(arrangedSubviews: [likebtn, shareBtn, downloadBtn, ellipis])
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
        
        NSLayoutConstraint.activate([
            
            albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            albumImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            albumImage.heightAnchor.constraint(equalToConstant: 355),
            albumImage.widthAnchor.constraint(equalToConstant:350),

            artistAviImage.heightAnchor.constraint(equalToConstant: 20),
            artistAviImage.widthAnchor.constraint(equalToConstant: 20),

            ContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ContainerStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            ContainerStack.trailingAnchor.constraint(equalTo: trailingAnchor),

            btnStack.trailingAnchor.constraint(equalTo: ContainerStack.trailingAnchor),
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSetTracks(data: [Track] ){
        self.tracks = data
    }
    
    func savedBtnTapped(){

        
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
        view.id = artistId
        vc?.pushViewController(view, animated: true)
    }
    @objc func playButtonTapped(){
        
        print( tracks)
        switch(type){
        case "Album":
            AudioManager.shared.initPlayer(track: nil, tracks: tracks)
        default:
            AudioManager.shared.initPlayer(track: track, tracks: nil)
        }
        

    }
    @objc func didTapButton(sender: UIButton){
        
        switch(sender.tag){
        case 0:
            savedBtnTapped()
            print("Save")
        case 1:
            print( "Share")
        case 2:
            print("Download")
        case 3:
            print("Options")
            let vc = OptionsViewController()
            vc.modalPresentationStyle = .popover
            window?.rootViewController?.present(vc, animated: true)
        default: return
        }
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
        btn.tag = 0
        return btn
    }()
    
    let shareBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    let downloadBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        btn.tag = 2
        return btn
    }()
    let ellipis: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.tag = 3
        btn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return btn
    }()
  
    var playBtn: UIButton = {
        
        let btn = UIButton()
        btn.setSystemImageWithConfigureation(systemImage: "play.fill", size: 20)
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
        seperator.backgroundColor = .tertiaryLabel
        
        tagline.textColor = .label
        tagline.font = UIFont.boldSystemFont(ofSize: 20)
        
        let stackView = UIStackView(arrangedSubviews: [tagline])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
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
class SectionHeaderWithButton: UICollectionReusableView, GestureAction {
  
    static let reuseIdentifier: String = "sectionHeaderWithButton"
    
    let title = UILabel()
    let tagline = UILabel()
    let moreBtn = UIButton()
    
    var navigationController: UINavigationController!
    var vc: UIViewController!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .tertiaryLabel
        
        tagline.textColor = .label
        tagline.font = UIFont.boldSystemFont(ofSize: 20)
        
        let hstack = UIStackView(arrangedSubviews: [tagline, button ])
        hstack.distribution = .equalSpacing
        hstack.axis = .horizontal
        
        
        let stackView = UIStackView(arrangedSubviews: [hstack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
      
    func didTap(_sender: CustomGestureRecognizer) {
        navigationController.pushViewController(vc, animated: true)
    }
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("See More", for: .normal)
        btn.titleLabel?.setFont(with: 10)
//        btn.tintColor = .secondaryLabel
        btn.tintColor = .purple
//        rgb(142, 5, 194)
//        btn.setTitleColor(UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(didTap(_sender:)), for: .touchUpInside)
        return btn
    }()
}
class TableviewSectionHeader: UIView {
    
    let title = UILabel()
    let tagline = UILabel()
    let moreBtn = UIButton()
    
    var navigationController: UINavigationController!
    var vc: UIViewController!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let seperator = UIView(frame: .zero)
        seperator.backgroundColor = .tertiaryLabel
        
        tagline.textColor = .label
        tagline.font = UIFont.boldSystemFont(ofSize: 20)
        
        let hstack = UIStackView(arrangedSubviews: [tagline, button ])
        hstack.distribution = .equalSpacing
        hstack.axis = .horizontal
        
        
        let stackView = UIStackView(arrangedSubviews: [hstack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            
            seperator.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
      
    func didTap(_sender: CustomGestureRecognizer) {
        navigationController.pushViewController(vc, animated: true)
    }
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("See More", for: .normal)
        btn.titleLabel?.setFont(with: 10)
        btn.tintColor = .secondaryLabel
//        btn.addTarget(self, action: #selector(didTap(_sender:)), for: .touchUpInside)
        return btn
    }()
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

        image.setUpImage(url: item.imageURL!, interactable: true)

        setupGradient()
    }

    func setupGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.1, 0.3]
        
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
    var user = UserDefaults.standard.value(forKey: "user")!
    
    var isFollowed = false
    var artist: Artist!
    
    let container = UIView(frame: .zero)
    
    var stack = UIStackView()
    
    var animator: UIViewPropertyAnimator!
    var profileStats:  ProfileOptionsView!
    
    override init(frame: CGRect){
        super.init( frame: frame)
        
        addSubview(image)
        backgroundColor = .black
        
        profileStats = ProfileOptionsView()
        profileStats.layer.zPosition = 5
        profileStats.translatesAutoresizingMaskIntoConstraints = false
        
        infoBtn.layer.zPosition = 5
        addSubview(profileStats)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalToConstant: 400),
            
            profileStats.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            profileStats.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileStats.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func setupHeader(artist: Artist){
        
        self.artist = artist
        setupGradient()
        let subscribers = NumberFormatter.localizedString(from: NSNumber(value: artist.subscribers), number: NumberFormatter.Style.decimal)

        profileStats.subscribersLabel.text = " \(artist.type) • Subscribers: \(subscribers)"
        profileStats.configure(artistId: artist.id)
    }
    
    func setupGradient(){
        
        let blurr = UIBlurEffect(style: .dark)
        let visualEffect = UIVisualEffectView(effect: blurr)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.1, 1.3]
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        container.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        addSubview(container)
        visualEffect.frame = container.frame
        visualEffect.clipsToBounds = true
        
        container.layer.addSublayer(gradientLayer)
//        container.addSubview(visualEffect)
        container.mask = visualEffect
        
        container.addSubview(name)
        
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 20),
            name.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10)
        ])
    }
    
   
    
    @objc func didTapInfoBtn(){
        
    }
    
    var image: UIImageView = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
        
    }()
    var name: UILabel = {
        let label = UILabel()
        label.setBoldFont(with: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var artistAvi: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let infoBtn: UIButton = {
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

class ProfileOptionsView: UIView {
    
    var artistId: String!
    var isFollowed: Bool = false
    let user = UserDefaults.standard.object(forKey: "user")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(artistId: String){
        
        self.artistId = artistId
        
        NetworkManager.Get(url: "user/subscriptions?id=\(artistId)&&user=\(self.artistId!)") { ( result: Data?, error: NetworkError ) in
            switch(error){
            case .notfound:
            
                self.isFollowed = false
                DispatchQueue.main.async {
                    self.followBtn.setTitle("Follow", for: .normal)
                }
            
            case .servererr:
                print("server error: ", error.localizedDescription)
            
            case .success:
                print("result")
                self.isFollowed = true
              
                DispatchQueue.main.async {
                    self.followBtn.setTitle("Following", for: .normal)
                }
            }
        }
        
        let stack = UIStackView(arrangedSubviews: [ followBtn, optionsBtn])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 10

        let containerStack = UIStackView(arrangedSubviews: [stack, subscribersLabel])
        containerStack.axis = .vertical
        containerStack.alignment = .leading
        containerStack.spacing = 10
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    @objc func didTapFollowBtn() {
        
        if(!isFollowed){
            
            NetworkManager.Post(url: "user/subscriptions?id=\(user)", data: artistId) { ( data: Data?, error: NetworkError) in
                switch(error){
                case .notfound:
                    print("internal error")
                    
                case .servererr:
                    print("error")
                    
                case .success:
                    
                    self.isFollowed = true
                    DispatchQueue.main.async {
                        self.followBtn.setTitle("Following", for: .normal)
                    }
                    
                }
            }
            
        }
        else{

            NetworkManager.Delete(url: "user/subscriptions?id=\(artistId)&&user=\(user)") { error in
                switch(error){
                case .servererr:
                    print("Internal server error")
                case .notfound:
                    print("could not complete request")
                
                case .success:
                    
                    self.isFollowed = false
                    DispatchQueue.main.async {
                        self.followBtn.setTitle("Follow", for: .normal)
                    }
                    
                }
            }
            
        }
        
        followBtn.setNeedsDisplay()
    }
    
    let followBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Follow", for:  .normal)
        btn.titleLabel!.setFont(with: 12)
        btn.setTitleColor(UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1).cgColor
        btn.addTarget(self, action: #selector(didTapFollowBtn), for: .touchUpInside)
        
        return btn
        
    }()
    let optionsBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let subscribersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 10)
        return label
    }()
}
class TableSectionHeader: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
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
class AlbumCover: UICollectionViewCell {
     
    static let reuseIdentifier: String = "albumCover"
    
    let image = UIImageView()
    let artist = UILabel()
    let title = UILabel()
    var type: String!
    
    var vc: UINavigationController!
    var tapgesture: CustomGestureRecognizer!
    
    let container: UIView = {
        let view = UIView()
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
        artist.setFont(with: 12)
        
        title.textColor = .label
        title.setBoldFont(with: 15)
        title.numberOfLines = 1
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [title, artist])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 0
        
        addSubview(image)
        addSubview(stackview)
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 160),
            image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15),
            
            stackview.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            stackview.widthAnchor.constraint(equalToConstant: 125)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(item: LibItem, navigationController: UINavigationController){
        image.setUpImage(url: item.imageURL!, interactable: true)
        title.text = item.title
        artist.text = item.name
        type = item.type
        
        tapgesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        tapgesture.id = item.id
        
        image.addGestureRecognizer(tapgesture)
        vc = navigationController
    }
    
    @objc func didTap(_sender: CustomGestureRecognizer) {

        print(_sender.id!)
        
        
        switch( type){
        case "Playlist":
            let view = PlaylistViewController()
            view.id = _sender.id!
            vc?.pushViewController(view, animated: true)
        
        case "Track":
            let view = TrackViewController()
            view.trackId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        default:
            let view = AlbumViewController()
            view.albumId = _sender.id!
            vc?.pushViewController(view, animated: true)
            
        }
        
    }
}
class TrackCover: UICollectionViewCell {
     
    static let reuseIdentifier: String = "trackCover"
    
    var vc: UINavigationController!
    var tapgesture: CustomGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackview = UIStackView(arrangedSubviews: [title, artist])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 0
        
        addSubview(image)
        addSubview(stackview)
//        addSubview(playBtn)
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 110),
            image.widthAnchor.constraint(equalToConstant: 120),
            image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15),
            
//            playBtn.centerXAnchor.constraint(equalTo: image.centerXAnchor),
//            playBtn.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            
            stackview.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            stackview.widthAnchor.constraint(equalToConstant: 125)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(item: LibItem, navigationController: UINavigationController){
        image.setUpImage(url: item.imageURL!, interactable: true)
        title.text = item.title
        artist.text = item.name
        
        tapgesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        
        
        let track = Track(id: item.id,
                          type: item.type!,
                          trackNum: nil,
                          title: item.title!,
                          artistId: item.artistId!,
                          name: item.name!,
                          imageURL: item.imageURL!,
                          albumId: item.albumId!,
                          audioURL: item.audioURL,
                          playCount: nil,
                          videoId: item.videoURL)
        
        tapgesture.track = track
        
        image.addGestureRecognizer(tapgesture)
        vc = navigationController
    }
    
    @objc func didTap(_sender: CustomGestureRecognizer) {

        AudioManager.shared.initPlayer(track: _sender.track, tracks: nil)
        
    }
    
    let image: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    let artist: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(with: 10)
        return label
    }()
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setBoldFont(with: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playBtn: UIButton = {
        let btnConfig = UIImage.SymbolConfiguration(pointSize: 50)
        let btn = UIButton()
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "play.circle", withConfiguration: btnConfig ), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
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
                      imageURL: item.imageURL!,
                      albumId: item.albumId!,
                      audioURL: item.audioURL!,
                      playCount: nil)
        
        chartPosition.text = "1"
        image.setUpImage(url: item.imageURL!, interactable: true)
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
        
        image.setUpImage(url: track.imageURL, interactable: true)
        name.text = track.title
        artist.text = track.name
        
    }
    
    func configureWithSet(image: String, name: String, artist: String, type: String) {

        self.image.setUpImage(url: image, interactable: true)
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
    var stackview: UIStackView!
    
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
        
        title.setFont(with: 15)
        
        artist.setFont(with: 12)
        artist.textColor = .secondaryLabel
        
        listenCount.setFont(with: 10)
        listenCount.textColor = .secondaryLabel
        listenCount.textAlignment = .right
//        listenCount.numberOfLines = 0
        listenCount.translatesAutoresizingMaskIntoConstraints = false
//        listenCount.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        chartPosition.setBoldFont(with: 15)
        chartPosition.textColor = .secondaryLabel
//        chartPosition.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configureWithChart(with catalog: Track, index: Int?, withChart: Bool) {
        
        image.setUpImage(url: catalog.imageURL, interactable: true)
        title.text = catalog.title
        title.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        artist.text = catalog.name
        artist.widthAnchor.constraint(equalToConstant: 200).isActive = true
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: catalog.playCount!), number: .decimal)
        
        let innterStackview = UIStackView(arrangedSubviews: [title, artist])
        innterStackview.axis = .vertical
        innterStackview.spacing = 5
        innterStackview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(image)
        addSubview(innterStackview)
        addSubview(listenCount)
        
        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .tertiaryLabel
        
        addSubview(seperator)
        
        switch(withChart){
        case false:
            
            NSLayoutConstraint.activate([
                contentView.heightAnchor.constraint(equalToConstant: 75),
                image.heightAnchor.constraint(equalToConstant: 100),
                image.widthAnchor.constraint(equalToConstant: 50),
                image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                image.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                innterStackview.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
                innterStackview.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                seperator.leadingAnchor.constraint(equalTo: innterStackview.leadingAnchor),
                seperator.trailingAnchor.constraint(equalTo: trailingAnchor),
                seperator.topAnchor.constraint(equalTo: innterStackview.bottomAnchor, constant: 10),
                seperator.heightAnchor.constraint(equalToConstant: 0.5),
    
                listenCount.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
                listenCount.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
            
            
        default:
            chartPosition.text = String(index! + 1)
            addSubview(chartPosition)
            
            NSLayoutConstraint.activate([
                
                chartPosition.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -20),
                chartPosition.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                image.heightAnchor.constraint(equalToConstant: 100),
                image.widthAnchor.constraint(equalToConstant: 50),
                image.leadingAnchor.constraint(equalTo: chartPosition.trailingAnchor, constant: 20),
                image.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                innterStackview.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
                innterStackview.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                listenCount.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
                listenCount.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
            
        }
    
    }
    
//    func didTap(_sender: CustomGestureRecognizer) {
//        AudioManager.shared.initPlayer(track: track, tracks: nil)
//    }
}
class LargeTrackComoponent: UITableViewCell {
    static let reuseIdentifier: String = "Trending"
    
//    var vc: UINavigationController?
//    var tapGesture: CustomGestureRecognizer?
    
    var stackview: UIStackView!
    
//    var track: Track!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
//        addGestureRecognizer(tapGesture!)

    
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configureWithChart(with catalog: Track, index: Int?, withChart: Bool) {
        
        image.setUpImage(url: catalog.imageURL, interactable: true)
        
        chartPosition.text = "#\(String(index! + 1))"
        
        title.text = catalog.title
        title.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        artist.text = catalog.name
        artist.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        listenCount.text = NumberFormatter.localizedString(from: NSNumber(value: catalog.playCount!), number: .decimal)
        
        let innterStackview = UIStackView(arrangedSubviews: [chartPosition,title, artist, listenCount])
        innterStackview.axis = .vertical
        innterStackview.translatesAutoresizingMaskIntoConstraints = false
        innterStackview.alignment = .leading
        innterStackview.spacing = 5
        
        addSubview(image)
        addSubview(innterStackview)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 120),
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            innterStackview.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            innterStackview.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
        
    }
    
//    func didTap(_sender: CustomGestureRecognizer) {
//        AudioManager.shared.initPlayer(track: track, tracks: nil)
//    }
    
    let chartPosition: UILabel = {
        let label = UILabel()
        label.setBoldFont(with: 20)
        label.textColor = .label
        return label
    }()
    let image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.setBoldFont(with: 20)
        return label
    }()
    let artist: UILabel = {
        let label = UILabel()
        label.setFont(with: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    let listenCount: UILabel = {
        let label = UILabel()
        label.setFont(with: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
}
class LargeAviTableCell: UITableViewCell {
    static var reuseableIdentifire: String = "LargeAvi"
    
    func configure(data: Artist){
    
        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        image.setUpImage(url: data.imageURL, interactable: true)
        
        ArtistNameLabel.text = data.name
        
        let stack = UIStackView(arrangedSubviews: [image, ArtistNameLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        
        addSubview(image)
        addSubview(ArtistNameLabel)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            ArtistNameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            ArtistNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
     
        ])
        
    }
    
    let image: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant:  100).isActive = true
        img.widthAnchor.constraint(equalToConstant: 100).isActive = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 50
        return img
    }()
    
    let ArtistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 15)
        return label
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .secondaryLabel
        return btn
    }()
    
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
        self.image.setUpImage(url: image, interactable: true)
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
        labelStack.distribution = .fillProportionally
        print(settinglabel)

        let containerStack = UIStackView(arrangedSubviews: [settingImage, labelStack])
        containerStack.axis = .horizontal
        containerStack.distribution = .equalSpacing
        containerStack.spacing = 20
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerStack)
        
        NSLayoutConstraint.activate( [
            
            settingImage.widthAnchor.constraint(equalToConstant: 30),
            
            labelStack.heightAnchor.constraint(equalToConstant: 30),
            
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
}
class PlayListCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "playlistCell"
    
    let image: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    let label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: image.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
class AlbumCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "albumCell"
    
    let image: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    let name: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFont(with: 10)
        view.textColor = .secondaryLabel
        return view
    }()
    let title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setFont(with: 12)
        view.textColor = .label
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(name)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            
            name.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: image.leadingAnchor)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
class ArtistFlowSectionContainer: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "artistFlowViewContainer"
    var nvc: UINavigationController!
    var artists: [LibItem]!
    
    var collectionview: UICollectionView!
    
    func configureCell(items: [LibItem], navigationController: UINavigationController){
        
        nvc = navigationController
        artists = items
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 100, height: 100)

        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionview.backgroundColor = .black
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ArtistSection.reuseIdentifier, for: indexPath) as! ArtistSection
        
        cell.configure(with: artists[indexPath.row], rootVc: nvc, indexPath: nil)
        
        return cell
    }
    
}
class AlbumFlowSection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "Album"
    
    var data = [LibItem]()
    var vc: UINavigationController!
    
    var collectionview: UICollectionView! = nil

    func configure(data: [LibItem], navigationController: UINavigationController){
        
        self.data = data
        vc =  navigationController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 165, height: 200)
        
        collectionview = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(AlbumCover.self, forCellWithReuseIdentifier: AlbumCover.reuseIdentifier)
        collectionview.backgroundColor = .black
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
    
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant:  200),
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
//        collectionview.backgroundColor = .red
        
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
class TrackFlowSection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "Track"
    
    var data = [LibItem]()
    var vc: UINavigationController!
    var type: String = ""
    
    var collectionview: UICollectionView! = nil

    func configure(data: [LibItem], navigationController: UINavigationController){
        
        self.data = data
        vc =  navigationController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 120, height: 150)
        
        collectionview = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(TrackCover.self, forCellWithReuseIdentifier: TrackCover.reuseIdentifier)
        collectionview.backgroundColor = .black
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
    
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant:  170),
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
//        collectionview.backgroundColor = .red
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: TrackCover.reuseIdentifier, for: indexPath) as! TrackCover
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
class videoCollectionFlowCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    static let reuseIdentifier: String = "videoCollection"
    var collectionView: UICollectionView!
    
    var data = [VideoItemModel]()
    var vc: UINavigationController!
    
    var collectionview: UICollectionView! = nil

    func configure(data: [VideoItemModel], navigationController: UINavigationController){
        
        self.data = data
        vc =  navigationController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 200, height: 150)

        collectionview = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(SmallVideoPoster.self, forCellWithReuseIdentifier: SmallVideoPoster.reuseIdentifier)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .black
        
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 190),
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: SmallVideoPoster.reuseIdentifier, for: indexPath) as! SmallVideoPoster
        
        cell.configure(with: data[indexPath.row], navigationController: vc)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
