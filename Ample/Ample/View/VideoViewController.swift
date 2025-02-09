//
//  VideoViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-04-15.
//

import UIKit
import AVFoundation
import AVKit
import CoreData

@objc protocol VideoPlayerViewDelegate {
    @objc func closePlayer(sender: UIButton)
}

protocol VideoPlayerDelegate {
    func playSelectedVideo(item: VideoItemModel)
}

class VideoPlayerManager {

    var delegate: VideoPlayerDelegate!

    func playSelectedVideo(item: VideoItemModel){
        
    }
}

class VideoViewController: UIViewController, UIScrollViewDelegate, VideoPlayerViewDelegate {
    
    func closePlayer(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    var selectedVideo: String?
    var playerDelegate: VideoPlayerDelegate!
//    var player: VideoPlayer!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoURL: URL!
    var playerItem: AVPlayerItem!
    var delegate: VideoPlayerViewDelegate!
    var audioPlayer = AudioManager.shared
    
    private var currentVideo: VideoItemModel!
    private var playerItemContext = 0
    private var playerViewController: AVPlayerViewController!
    private var timeObserverToken: Any?
    
    var tableview: UITableView!
    
    //Video
    var videoHeight: CGFloat = 200
    var videoWidth: CGFloat = 200
    
    var videoFrame = CGRect(x: 0, y: 260, width: UIScreen.main.bounds.width, height: 300)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
         UIDevice.current.setValue(value, forKey: "orientation")
        
        setupPlayer(video: nil)
//        NetworkManager.Get(url:"videos?id=\(selectedVideo!)" ) { (data: VideoItemModel?, error: NetworkError) in
//               switch(error) {
//               case .notfound:
//                   print( "resource not found with provided url")
//
//               case .servererr:
//                   print( "internal server error")
//
//               case .success:
//                   print( data! )
//                   DispatchQueue.main.async {
//                       self.setupPlayer(video: data!)
//                   }
//               }
//           }
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeTimeObserver()
    }
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    func removeTimeObserver(){
        if let token = timeObserverToken {
            player.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    func setupPlayer(video: VideoItemModel?){
        
//        currentVideo = video
        
        videoURL = URL(string: String("http://localhost:8000/"))
        
        let asset = AVAsset(url: videoURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoFrame
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)

        view.addSubview(controlContainer)

        controlContainer.translatesAutoresizingMaskIntoConstraints = false
        controlContainer.layer.zPosition = 1

        let videoControlls = UIStackView(arrangedSubviews: [prevBtn, playBtn, nextBtn])
        videoControlls.axis = .horizontal
        videoControlls.distribution = .equalSpacing
        videoControlls.spacing = 5
        videoControlls.translatesAutoresizingMaskIntoConstraints = false

        controlContainer.addSubview(videoControlls)

        if( player.rate > 0){
            playBtn.setSystemImageWithConfigureation(systemImage: "pause.fill", size: 20)
        }else{
            playBtn.setSystemImageWithConfigureation(systemImage: "play.fill", size: 20)
        }
        
        if audioPlayer.currentQueue != nil {
            audioPlayer.player.pause()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
        }
        
        controlContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideControls)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showControls)))

        let videoDetailStack = UIStackView(arrangedSubviews: [artistNameLabel, videoTitleLabel])
        videoDetailStack.axis = .vertical
        videoDetailStack.spacing = 2
        videoDetailStack.alignment = .leading
        
//        videoTitleLabel.text = video.title
//        artistNameLabel.text = video.artist
        
        videoTimeDuration.text = "0:00 / 3:00"
        
        let timeLabelStack = UIStackView(arrangedSubviews: [videoTimeDuration ])
        timeLabelStack.axis = .horizontal
        timeLabelStack.distribution = .fillProportionally
        timeLabelStack.spacing = 5
        timeLabelStack.alignment = .center
        timeLabelStack.translatesAutoresizingMaskIntoConstraints = false
        
        let progressStack = UIStackView(arrangedSubviews: [progressBar, fullScreenBtn] )
        progressStack.axis = .horizontal
        progressStack.spacing = 2
        
        let progressContainer = UIStackView(arrangedSubviews: [timeLabelStack, progressStack])
        progressContainer.axis = .vertical
        progressContainer.distribution = .fillProportionally
        progressContainer.spacing = 5
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let trackInfoContainer = UIStackView(arrangedSubviews: [videoDetailStack , progressContainer])
        trackInfoContainer.axis = .vertical
        trackInfoContainer.distribution = .fillProportionally
        trackInfoContainer.alignment = .leading
        trackInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        trackInfoContainer.axis = .vertical
        trackInfoContainer.spacing = 10
        
        controlContainer.addSubview(trackInfoContainer)
        controlContainer.addSubview(closeBtn)
        controlContainer.addSubview(optionsButton)
        
        NSLayoutConstraint.activate([

            controlContainer.topAnchor.constraint(equalTo: view.topAnchor),
            controlContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            videoControlls.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 50),
            videoControlls.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor, constant: -50),
            videoControlls.centerYAnchor.constraint(equalTo: controlContainer.centerYAnchor),

            closeBtn.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 20),
            closeBtn.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 50),
//
            optionsButton.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor, constant: -20),
            optionsButton.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 50),
            
            trackInfoContainer.bottomAnchor.constraint(equalTo: controlContainer.bottomAnchor, constant: -50),
            trackInfoContainer.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 20),
            trackInfoContainer.trailingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: -20),
            
            progressBar.heightAnchor.constraint(equalToConstant: 5),
            progressBar.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor, constant: -20),
            progressBar.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 20)
        ])
        
        
    }
    
    func rotateVideo(){
        
        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = "transform.rotation.z"
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi / 2
        rotationAnimation.duration = 1
        
        playerLayer.add(rotationAnimation, forKey: "basic.")
        playerLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 0)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        animate()
    }
    
    func animate(){
        
        let videAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            self.videoFrame  = CGRect(x: 0, y: 0, width: 200, height: 400)
            self.view.layoutIfNeeded()
        }
        
        videAnimator.startAnimation()
    }
    
    func addPeriodicTimeObserver(){
        
        let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_MSEC))
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .second ]
        formatter.zeroFormattingBehavior = [ .dropTrailing ]
        
       timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main) { time in

           print( Int(time.value / Int64(time.timescale)))
           
//           print( "Seconds: ", formatter.string(from: DateComponens( self.player.currentTime().seconds)
//           print("Minutes: ", self.player.currentTime().seconds / 60)
           
//           self.totalTrackTime.text = self.formatter.string(from: self.audioManager.player.currentTime - self.audioManager.player.duration)
           
           if self.player.timeControlStatus != .paused {
               self.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
               self.playBtn.setNeedsDisplay()
           }
           
           self.progressBar.setProgress(Float(CMTimeGetSeconds(self.player.currentTime()) / CMTimeGetSeconds(self.playerItem.duration )), animated: true)
            
        }
        
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
            
                player.play()
                
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
    override func viewWillLayoutSubviews() {
    }
    
    @objc func hideControls(){
        controlContainer.isHidden = true
    }
    @objc func showControls(){
        controlContainer.isHidden = false
    }
    @objc func togglePlayback(){
        if(player.rate > 0){
            player.rate = 0
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.playBtn.setNeedsDisplay()
            }
        }else{
            player.rate = 1
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.playBtn.setNeedsDisplay()
            }
        }
    }
    @objc func didPressCloseButton(sender: UIButton) {
        player.rate = 0
        closePlayer(sender: sender)
    }
    
    let controlContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        return view
    }()
    let VideoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    let playBtn: UIButton = {
        
        let btnConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let btn = UIButton()
        btn.setSystemImageWithConfigureation(systemImage: "play.fill", size: 20)
        btn.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        btn.tintColor = .label
        return btn
    }()
    let nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    let prevBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    let closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btn.addTarget(self, action: #selector(didPressCloseButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .label
        return btn
    }()
    let progressBar: UIProgressView = {
        let slider = UIProgressView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.layer.zPosition = 5
        slider.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        return slider
    }()

    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.setFont(with:  15)
        label.textColor = .label
        return label
    }()
    let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.setFont(with:  20)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    let videoTimeDuration: UILabel = {
        let label = UILabel()
        label.setFont(with:  15)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textColor = .label
        return label
    }()
    
    let likeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    let optionsButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .label
        return btn
    }()
    let viewsCounterBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    let fullScreenBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "viewfinder"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
}

class LargeVideoCell: UITableViewCell {
    static let reuseIdentifier: String = "largeVideoCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with: VideoItemModel ){
        
        let contentStack = UIStackView(arrangedSubviews: [artistName, videoTitle, viewCounter])
        contentStack.axis = .vertical
        contentStack.distribution = .fillProportionally
        contentStack.spacing = 5
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStack)
        
        artistName.text = with.artist
        videoTitle.text = with.title
        viewCounter.text = "Views: \(String(with.views!))"
        container.setUpImage(url: with.posterURL!, interactable: false)
        
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 20)
        ])
        
    }
    
    let container: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let artistName: UILabel = {
        let view = UILabel()
        view.setFont(with: 12)
        view.textColor = .label
        return view
    }()
    
    let videoTitle: UILabel = {
        let label = UILabel()
        label.setFont(with: 20)
        label.textColor = .label
        return label
    }()
    
    let viewCounter: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 10)
        return label
    }()
}


class VideoPlayer: UIView{
   
    
        
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoURL: URL!
    var playerItem: AVPlayerItem!
    var delegate: VideoPlayerViewDelegate!
    var playerDelegate: VideoPlayerDelegate!
    var audioPlayer = AudioManager.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
            
        if(audioPlayer.player != nil){
            audioPlayer.player.pause()
        }
    }
 
    func setupPlayer(item: VideoItemModel){
        videoURL = URL(string: item.videoURL)
        playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.position = CGPoint(x: 0, y: bounds.minY)

        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds

        player.play()
//        player.volume = 0

        addSubview(controlContainer)
        controlContainer.frame = bounds
        controlContainer.layer.zPosition = 1
        
        let videoControlls = UIStackView(arrangedSubviews: [prevBtn, playBtn, nextBtn])
        videoControlls.axis = .horizontal
        videoControlls.distribution = .equalSpacing
        videoControlls.spacing = 5
        videoControlls.translatesAutoresizingMaskIntoConstraints = false

        controlContainer.addSubview(videoControlls)
        controlContainer.addSubview(closeBtn)
        
        if( player.rate > 0){
            playBtn.setSystemImageWithConfigureation(systemImage: "pause.fill", size: 20)
        }else{
            playBtn.setSystemImageWithConfigureation(systemImage: "play.fill", size: 20)
        }
        
        controlContainer.isHidden = true
        controlContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideControls)))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showControls)))
        
        addSubview(progressBar)
        
        
        NSLayoutConstraint.activate([
//
            videoControlls.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 50),
            videoControlls.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor, constant: -50),
            videoControlls.centerYAnchor.constraint(equalTo: controlContainer.centerYAnchor),

            closeBtn.leadingAnchor.constraint(equalTo: controlContainer.leadingAnchor, constant: 20),
            closeBtn.topAnchor.constraint(equalTo: controlContainer.topAnchor, constant: 50),
//
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo:trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 5)
        ])
    
    }
    
    @objc func hideControls(){
        controlContainer.isHidden = true
    }
    @objc func showControls(){
        controlContainer.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    @objc func didPressCloseButton(sender: UIButton) {
        player.rate = 0
        delegate.closePlayer(sender: sender)
    }
    
    func playSelectedVideo(item: VideoItemModel) {
        let item = AVPlayerItem(url: URL(string: item.videoURL)!)
        DispatchQueue.main.async {
            self.player.replaceCurrentItem(with: item)
        }
    }
    
    @objc func togglePlayback(){
        if(player.rate > 0){
            player.rate = 0
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self.playBtn.setNeedsDisplay()
            }
        }else{
            player.rate = 1
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.playBtn.setNeedsDisplay()
            }
        }
    }
    
    let controlContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        return view
    }()
    
    let VideoContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        view.backgroundColor = .black
        return view
    }()
    
    
    let playBtn: UIButton = {
        
        let btnConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let btn = UIButton()
        btn.setSystemImageWithConfigureation(systemImage: "play.fill", size: 20)
        btn.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        return btn
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        return btn
    }()
    
    let prevBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        return btn
    }()
    
    let closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        btn.addTarget(self, action: #selector(didPressCloseButton), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let progressBar: UISlider = {
        let slider = UISlider()
//        slider.setValue(1, animated: true)
        slider.isContinuous = true
        slider.setThumbImage(UIImage(), for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.layer.zPosition = 5
        return slider
    }()
    
    let artistImage: UIImageView = {
        let image = UIImageView()
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.setFont(with:  15)
        label.textColor = .label
        return label
    }()
    
    let videoTitleLabel: UILabel = {
        let label = UILabel()
        label.setFont(with:  20)
        label.textColor = .label
        return label
    }()
    
    let viewCounter: UILabel = {
        let label = UILabel()
        label.setFont(with:  10)
        label.textColor = .secondaryLabel
        return label
    }()
}

extension UIButton{
    
    func setSystemImageWithConfigureation(systemImage: String, size: CGFloat){
        setImage(UIImage(systemName: systemImage, withConfiguration: UIImage.SymbolConfiguration(pointSize: size)), for: .normal)
    }
}
