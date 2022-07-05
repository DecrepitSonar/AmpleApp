//
//  PlayerViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/20/21.
//

import UIKit
import AudioToolbox

class PlayerViewController: UIViewController {
    
    var currentTrack: Track!
    var timer: Timer!
    var elapsedTimeInSecond: Int = 0
    
    let audioManager = AudioManager.shared
    let formatter = DateComponentsFormatter()
    var effect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var animator: UIViewPropertyAnimator!
    let playbtnImg = UIImage(systemName: "play.circle.fill")!
        .applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 50))
    
    let pauseBtnImg = UIImage(systemName: "pause.circle.fill")!
        .applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 50))
    
    override open var shouldAutorotate: Bool {
          return false
      }
    
    override func loadView() {
        super.loadView()
        overrideUserInterfaceStyle = .dark
        
        currentTrack = audioManager.getCurrentTrack()
        view.backgroundColor = image.image?.averageColor
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .dropTrailing ]
        
        title = audioManager.currentQueue!.title
        
        let closeBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 15)), style: .plain, target: self, action: #selector(closePlayer))
        closeBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        navigationItem.leftBarButtonItem = closeBtn
        
        let optionBtn = UIBarButtonItem(image: UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 15)), style: .plain, target: self, action: #selector(openOptionView))
        
        optionBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        navigationItem.rightBarButtonItem = optionBtn
        
        timer =  Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: #selector(updateTrackTiming),
                                      userInfo: nil, repeats: true)
        
        view.addSubview(effect)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(updatePlayer),
//                                               name: Notification.Name("update"),
//                                               object: nil)
//
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTrackTiming),
                                               name: Notification.Name("update"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(togglePlayBtn),
                                               name: NSNotification.Name("isPlaying"),
                                               object: nil)
        
        timer =  Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: #selector(updateTrackTiming),
                                      userInfo: nil,
                                      repeats: true)
        
        view.addSubview(image)
        
        if audioManager.currentQueue?.videoId == nil{
            videoAvailabilityBtn.setImage(UIImage(systemName: "display.trianglebadge.exclamationmark"), for: .normal)
        }
        
        let optionStack = UIStackView(arrangedSubviews: [queue, videoAvailabilityBtn])
        optionStack.axis = .horizontal
        optionStack.alignment = .leading
        optionStack.spacing = 20
        optionStack.distribution = .equalSpacing
        
        let labelStack = UIStackView(arrangedSubviews: [trackTitle, artist])
        labelStack.axis = .vertical
        labelStack.distribution = .equalCentering
        labelStack.spacing = 5
        
        let labelContainerStack = UIStackView(arrangedSubviews: [labelStack, likeBtn])
        labelContainerStack.distribution = .equalSpacing
        labelContainerStack.axis = .horizontal
        
        
        let buttonStack = UIStackView(arrangedSubviews: [shuffleBtn, prevBtn, playBtn, forwardBtn, repeatBtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillProportionally
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let timerStack = UIStackView(arrangedSubviews: [ totalTimeLapsed, totalTrackTime ])
        timerStack.axis = .horizontal
        timerStack.spacing = 5
        timerStack.distribution = .equalSpacing
        
        let sliderStack = UIStackView(arrangedSubviews: [slider, timerStack ])
        sliderStack.axis = .vertical
        sliderStack.spacing = 5
        sliderStack.distribution = .equalSpacing
        
        let stackControls = UIStackView(arrangedSubviews: [labelContainerStack, sliderStack, buttonStack, optionStack ])
        stackControls.axis = .vertical
        stackControls.spacing = 25
        stackControls.distribution = .equalSpacing
        stackControls.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackControls)

        NSLayoutConstraint.activate([

            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 340),
            image.widthAnchor.constraint(equalToConstant: 340),
            
//            trackTitle.widthAnchor.constraint(equalToConstant: 340),
            
            slider.widthAnchor.constraint(equalToConstant:  340),
            slider.heightAnchor.constraint(equalToConstant: 10),
            
            stackControls.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackControls.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            image.bottomAnchor.constraint(equalTo: stackControls.topAnchor, constant: -75),
            
        ])
        
    }
    override func viewWillLayoutSubviews() {
        
        var attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15)!]
        navigationController?.navigationBar.titleTextAttributes = attributes
        title = audioManager.currentQueue!.title
        
        effect.frame = view.bounds
        
        image.setUpImage(url:  audioManager.currentQueue!.imageURL, interactable: false)
        
        artist.text = audioManager.currentQueue!.name
        
        trackTitle.text = audioManager.currentQueue!.title
        
//        slider.setThumbImage(sliderThumbImage, for: .normal)
        slider.maximumValue = Float(audioManager.player.duration)
        slider.value = Float(audioManager.player.currentTime)
        
        totalTrackTime.text = formatter.string(from: audioManager.player.currentTime - audioManager.player.duration)
        totalTimeLapsed.text = formatter.string(from: audioManager.player.currentTime)
        
        
        if( audioManager.player != nil){
            audioManager.player.isPlaying ? playBtn.setImage(pauseBtnImg, for: .normal) : playBtn.setImage(playbtnImg, for: .normal)
        }
        view.backgroundColor = image.image?.averageColor

    }
    
    @objc func onSliderTouchOrDrag(sender: UISlider, event: UIEvent){
        
        timer.invalidate()
        
        if let touch = event.allTouches?.first {
            switch(touch.phase){
            
            case .began:
                print("touch begain at slide ")
                print(sender.value)
                
            case .ended:
                print("ended at: ", sender.value)
                audioManager.player.currentTime = Double(sender.value)
                
                timer =  Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTrackTiming),
                                              userInfo: nil, repeats: true)

            default:
                break
            }
        }
    }
    @objc func togglePlayState(){
        
        if(audioManager.player.isPlaying && audioManager.player != nil){
            audioManager.playerController(option: .pause)
        }
        else{
            timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
            audioManager.playerController(option: .resume)
        }
    }
    @objc func playnext(){
        
        audioManager.playerController(option: .next)
    }
    @objc func prev(){
        audioManager.playerController(option: .previous)
        timer =  Timer.scheduledTimer(timeInterval: 0.1,
                                      target: self,
                                      selector: #selector(updateTrackTiming),
                                      userInfo: nil,
                                      repeats: true)
    }
    @objc func togglePlayBtn(sender: Notification){
        
        if (audioManager.player.isPlaying){
            
            DispatchQueue.main.async {
                self.playBtn.setImage(self.pauseBtnImg, for: .normal)
            }
            
        }else{
            
            DispatchQueue.main.async {
                self.playBtn.setImage(self.playbtnImg, for: .normal)
            }
        }
    }
    @objc func updateTrackTiming(){
        
        DispatchQueue.main.async {
            
            self.totalTimeLapsed.text = self.formatter.string(from: self.audioManager.player.currentTime )
            
            self.totalTrackTime.text = self.formatter.string(from: self.audioManager.player.currentTime - self.audioManager.player.duration)
        }
        
    }
    @objc func openQueue(){
        
        let view = TrackQueueListViewController()
        view.queue = audioManager.getAudioQueue()
        
        print("queue")
        present(view, animated: true)
                
    }
    @objc func openOptionView(){
        let vc =  OptionsViewController()
        vc.track = audioManager.currentQueue
        vc.type = .Track
        vc.nvc = self.navigationController
        navigationController!.present(UINavigationController(rootViewController: vc), animated: true)
    }
    @objc func closePlayer(){
        dismiss(animated: true)
    }
    @objc func saveTrack(){
//        if(audioManager.isSaved){
//            NetworkManager.Delete(url: <#T##String#>, completion: <#T##(NetworkError) -> ()#>)
//        }
//        else{
//            NetworkManager.Post(url: <#T##String#>, data: <#T##Encodable#>, completion: <#T##(Decodable?, NetworkError) -> ()#>)
//        }
    }

    let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 5
        img.clipsToBounds = true
        return img
    }()
    let totalTrackTime: UILabel = {
        let label = UILabel()
        label.setFont(with: 12)
        return label
    }()
    let totalTimeLapsed: UILabel = {
        let label = UILabel()
        label.setFont(with: 12)
        return label
    }()
    let likeBtn: UIButton = {
        let likeBtnImg = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let likeBtnImgFill = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let btn = UIButton()
        
        if(AudioManager.shared.isSaved){
            btn.setImage(likeBtnImgFill, for: .normal)
        }
        else{
            btn.setImage(likeBtnImg, for: .normal)
        }
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(saveTrack), for: .touchUpInside)
        
        return btn
    }()
    let shareBtn: UIButton = {
        
        let sharebtnImg = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let btn = UIButton()
        btn.setImage(sharebtnImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
    let artist: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 12)
        return label
    }()
    let trackTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    let slider: UISlider = {
        let view = UISlider()
        view.setThumbImage(UIImage(), for: .normal)
        view.value = 0
        view.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        view.addTarget(self, action: #selector(onSliderTouchOrDrag(sender:event:)), for: .valueChanged)
        return view
    }()
    let forwardBtn: UIButton = {
        
        let forwardbtnImg = UIImage(systemName: "forward.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25))
        
        
        let btn = UIButton()
        btn.setImage(forwardbtnImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(playnext), for: .touchUpInside)
        return btn
    }()
    let playBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        btn.addTarget(self, action: #selector(togglePlayState), for: .touchUpInside)
        return btn
    }()
    let prevBtn: UIButton = {
        let prevbtnImg = UIImage(systemName: "backward.fill")!
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25))
        
        let btn = UIButton()
        btn.setImage(prevbtnImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(prev), for: .touchUpInside)
        return btn
    }()
    let shuffleBtn: UIButton = {
        
        let shuffleImg = UIImage(systemName: "shuffle", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let btn = UIButton()
        btn.setImage(shuffleImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
    let repeatBtn: UIButton = {
        
        let repeatImg = UIImage(systemName: "repeat", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let btn = UIButton()
        btn.setImage(repeatImg, for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        return btn
    }()
    let queue: UIButton = {
        
        let queueImag = UIImage(systemName: "list.number", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let btn = UIButton()
        btn.setImage(queueImag, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(openQueue), for: .touchUpInside)
        return btn
    }()
    let sliderThumbImage: UIView = {
        let thumb = UIView()
        thumb.heightAnchor.constraint(equalToConstant: 5).isActive = true
        thumb.widthAnchor.constraint(equalToConstant: 5)
        thumb.backgroundColor = .red
        return thumb
    }()
    let videoAvailabilityBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "play.tv"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(playAvailableVideo), for: .touchUpInside)
        return btn
    }()
    
    @objc func playAvailableVideo(){
        let videoView = VideoViewController()
        
        guard audioManager.currentQueue!.videoId != nil else {
            return
        }
        
        videoView.selectedVideo = audioManager.currentQueue!.videoId!
    
        videoView.title = "VideoPlayer"
        navigationController?.pushViewController(videoView, animated: true)
//        print("pressed")
        audioManager.player.pause()
        
    }
}
