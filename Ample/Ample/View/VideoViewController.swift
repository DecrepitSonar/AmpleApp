//
//  VideoViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-04-15.
//

import UIKit
import AVFoundation
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

//extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return videos.count
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        playSelectedVideo(item: videos[indexPath.row])
//        print("Selected")
//        print(videos[indexPath.row])
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableview.dequeueReusableCell(withIdentifier: LargeVideoCell.reuseIdentifier) as! LargeVideoCell
//
//        cell.configure(with: videos[indexPath.row])
//        cell.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        return cell
//    }
//
//
//}

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
//    var playerDelegate: VideoPlayerDelegate!
    var audioPlayer = AudioManager.shared
    
    var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .black
        
        NetworkManager.Get(url:"videos?id=\(selectedVideo!)" ) { (data: VideoItemModel?, error: NetworkError) in
               switch(error) {
               case .notfound:
                   print( "resource not found with provided url")
                   
               case .servererr:
                   print( "internal server error")

               case .success:
                   print( data! )
                   DispatchQueue.main.async {
                       self.setupPlayer(video: data!)
                   }
               }
           }
    }
    
    func setupPlayer(video: VideoItemModel){
        
        videoURL = URL(string: String(video.videoURL))
        let asset = AVAsset(url: videoURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.bounds

        player.play()
//        player.volume = 0
//
        view.addSubview(controlContainer)
        controlContainer.frame = view.bounds
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
        
        if audioPlayer.currentQueue! != nil {
            audioPlayer.player.pause()
        }

        controlContainer.isHidden = true
        controlContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideControls)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showControls)))

        let artistStack = UIStackView(arrangedSubviews: [artistImage, artistNameLabel])
        artistStack.axis = .horizontal
        artistStack.spacing = 10
        artistStack.alignment = .center
        artistImage.setUpImage(url: video.artistImageURL!, interactable: true)
        
        let progressStack = UIStackView(arrangedSubviews: [progressBar, totalRemainingTimeLabel] )
        progressStack.axis = .horizontal
        progressStack.spacing = 10
        
        
        let trackInfoContainer = UIStackView(arrangedSubviews: [artistStack,videoTitleLabel, progressStack])
        trackInfoContainer.axis = .horizontal
        trackInfoContainer.distribution = .fillProportionally
        trackInfoContainer.alignment = .leading
        trackInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        trackInfoContainer.axis = .vertical
        trackInfoContainer.spacing = 10
        
        videoTitleLabel.text = video.title
        artistNameLabel.text = video.artist
        viewCounter.text = String(video.views)
        
        let buttonStack = UIStackView(arrangedSubviews: [likeButton, viewsCounterBtn,viewCounter, shareButton ,fullScreenBtn])
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 5
        buttonStack.alignment = .center
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        controlContainer.addSubview(trackInfoContainer)
        controlContainer.addSubview(buttonStack)
        controlContainer.addSubview(closeBtn)
        controlContainer.addSubview(optionsButton)
        
        
        NSLayoutConstraint.activate([

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
            trackInfoContainer.trailingAnchor.constraint(equalTo: buttonStack.leadingAnchor, constant: -20),
            trackInfoContainer.heightAnchor.constraint(equalToConstant: 90),
            
            progressBar.heightAnchor.constraint(equalToConstant: 10),
            progressBar.widthAnchor.constraint(equalToConstant: 270),
            
            buttonStack.leadingAnchor.constraint(equalTo: trackInfoContainer.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: controlContainer.bottomAnchor, constant: -30),
            buttonStack.trailingAnchor.constraint(equalTo: controlContainer.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 200),
            buttonStack.widthAnchor.constraint(equalToConstant: 50)
        ])
    
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        view.backgroundColor = .black
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
        btn.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    let prevBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
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
    let totalRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.setFont(with: 10)
        label.text = "2:23"
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
        viewCounter.text = "Views: \(String(with.views))"
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
