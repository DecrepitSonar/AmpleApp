//
//  PlayerViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/20/21.
//

import UIKit
import AVFAudio

class PlayerViewController: UIViewController {
    
    let audioManager = AudioManager.shared
    
    var currentTrack: Track!
    let formatter = DateComponentsFormatter()
    
    var timer: Timer!
    var effect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    let image = UIImageView()
    
    let closeBtn = UIButton()
    
    let totalTrackTime = UILabel()
    let totalTimeLapsed = UILabel()
    
    let optionBtn = UIButton()
    let likeBtn = UIButton()
    let shareBtn = UIButton()
    
    let artist = UILabel()
    let trackTitle = UILabel()
     
    let slider = UISlider()
    
    let forwardBtn = UIButton()
    let playBtn = UIButton()
    let prevBtn = UIButton()
    
    let shuffleBtn = UIButton()
    let repeatBtn = UIButton()
    
    let queue = UIButton()
    
    var animator: UIViewPropertyAnimator!
    
    let playbtnImg = UIImage(systemName: "play.circle.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 50))
    let pauseBtnImg = UIImage(systemName: "pause.circle.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemRed
        
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .dropTrailing ]
        
        navigationController?.isToolbarHidden = true
        currentTrack = audioManager.getCurrentTrack()
        view.addSubview(effect)
        effect.frame = view.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayer), name: Notification.Name("update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTrackTiming), name: Notification.Name("update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(togglePlayBtn), name: NSNotification.Name("isPlaying"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
        
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)

        image.setUpImage(url:  currentTrack.imageURL)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        view.addSubview(image)
        
        let prevbtnImg = UIImage(systemName: "backward.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25))
       
        let forwardbtnImg = UIImage(systemName: "forward.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25))
        
        let optionBtnImg = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let sharebtnImg = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let likeBtnImg = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let shuffleImg = UIImage(systemName: "shuffle", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let repeatImg = UIImage(systemName: "repeat", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        prevBtn.setImage(prevbtnImg, for: .normal)
        prevBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        prevBtn.addTarget(self, action: #selector(prev), for: .touchUpInside)
        
        if( audioManager.player != nil){
            audioManager.player.isPlaying ? playBtn.setImage(pauseBtnImg, for: .normal) : playBtn.setImage(playbtnImg, for: .normal)
        }
    
        playBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        playBtn.addTarget(self, action: #selector(togglePlayState), for: .touchUpInside)
        
        forwardBtn.setImage(forwardbtnImg, for: .normal)
        forwardBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        forwardBtn.addTarget(self, action: #selector(playnext), for: .touchUpInside)
        
        shuffleBtn.setImage(shuffleImg, for: .normal)
        shuffleBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
    
        repeatBtn.setImage(repeatImg, for: .normal)
        repeatBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        artist.text = currentTrack.name
        artist.textColor = .label
        artist.setFont(with: 12)
        
        trackTitle.text = currentTrack.title
        trackTitle.widthAnchor.constraint(equalToConstant: 340).isActive = true
        
        optionBtn.setImage(optionBtnImg, for: .normal)
        optionBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        shareBtn.setImage(sharebtnImg, for: .normal)
        shareBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        likeBtn.setImage(likeBtnImg, for: .normal)
        likeBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        let optionStack = UIStackView(arrangedSubviews: [likeBtn,queue, shareBtn, optionBtn])
        optionStack.axis = .horizontal
        optionStack.alignment = .leading
        optionStack.spacing = 20
        optionStack.distribution = .equalSpacing
        
        let labelStack = UIStackView(arrangedSubviews: [trackTitle, artist])
        labelStack.axis = .vertical
        labelStack.distribution = .equalCentering
        labelStack.spacing = 5
        
        let buttonStack = UIStackView(arrangedSubviews: [shuffleBtn, prevBtn, playBtn, forwardBtn, repeatBtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillProportionally
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        slider.setThumbImage(UIImage(), for: .normal)
        slider.value = 0
        slider.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        slider.maximumValue = Float(audioManager.player.duration)
        slider.addTarget(self, action: #selector(onSliderTouchOrDrag(sender:event:)), for: .valueChanged)
        
        totalTrackTime.setFont(with: 12)
        totalTrackTime.text = formatter.string(from: audioManager.player.currentTime - audioManager.player.duration)
        
        totalTimeLapsed.setFont(with: 12)
        totalTimeLapsed.text = formatter.string(from: audioManager.player.currentTime)
    
        let sliderStack = UIStackView(arrangedSubviews: [ totalTimeLapsed, totalTrackTime ])
        sliderStack.axis = .horizontal
        sliderStack.spacing = 10
        sliderStack.distribution = .equalSpacing
        
        let queueImag = UIImage(systemName: "list.number", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        queue.setImage(queueImag, for: .normal)
        queue.translatesAutoresizingMaskIntoConstraints = false
        queue.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        queue.addTarget(self, action: #selector(openQueue), for: .touchUpInside)
        
        let stackControls = UIStackView(arrangedSubviews: [labelStack, sliderStack, slider, buttonStack, optionStack ])
        
        stackControls.axis = .vertical
        stackControls.spacing = 25
        stackControls.distribution = .equalSpacing
        stackControls.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackControls)
        
        closeBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closePlayer), for: .touchUpInside)
        closeBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)

        view.addSubview(closeBtn)
////
        NSLayoutConstraint.activate([

            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 340),
            image.widthAnchor.constraint(equalToConstant: 340),
            
            
            slider.widthAnchor.constraint(equalToConstant:  340),
            slider.heightAnchor.constraint(equalToConstant: 10),
            
            stackControls.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackControls.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            image.bottomAnchor.constraint(equalTo: stackControls.topAnchor, constant: -75),
            
            closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
//
        ])
        
        
        
    }

    @objc func onSliderTouchOrDrag(sender: UISlider, event: UIEvent){
        
        timer.invalidate()
        if let touch = event.allTouches?.first {
            switch(touch.phase){
                
            case .ended:
                print("ended at: ", sender.value)
                audioManager.player.currentTime = Double(sender.value)
                timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)

            default:
                break
            }
        }
    }
    
    @objc func togglePlayState(){
        
        if(audioManager.player!.isPlaying && audioManager.player != nil){
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
        timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
    }
    @objc func togglePlayBtn(sender: Notification){
        
        if (audioManager.player!.isPlaying){
            
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
        
//        print(audioManager.checkTrackIsEnded(timer: timer))
        if audioManager.checkTrackIsEnded(timer: timer) {
            timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
            slider.maximumValue = Float(audioManager.player.duration)
            return
        }
        
        DispatchQueue.main.async {
            
            self.totalTimeLapsed.text = self.formatter.string(from: self.audioManager.player.currentTime )
            
            self.totalTrackTime.text = self.formatter.string(from: self.audioManager.player.currentTime - self.audioManager.player.duration)
            self.slider.setValue(Float(self.audioManager.player.currentTime), animated: true)
        }
        
    }
    
    
    @objc func openQueue(){
        
        let view = TrackQueueListViewController()
        view.queue = audioManager.getAudioQueue()
        
        print("queue")
        present(view, animated: true)
                
    }
    
    @objc func closePlayer(){
        dismiss(animated: true)
        print("animator")
    }
    @objc func updatePlayer(sender: Notification){
        
        
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            self.slider.maximumValue = Float(self.audioManager.player.duration)
            self.totalTrackTime.text = self.formatter.string(from: self.audioManager.player.duration)
            self.slider.setNeedsDisplay()

            self.image.setUpImage(url: self.audioManager.currentQueue!.imageURL)
            self.artist.text = self.audioManager.currentQueue!.name
            self.trackTitle.text = self.audioManager.currentQueue!.title

        }
    }

//    @objc func openQueueList(){
//        
//        let queue = TrackQueueListViewController()
//        print("opening player")
//           
//        print("presenting player")
//        queue.modalPresentationStyle = .overFullScreen
//        navigationController!.present(queue, animated: true)
//        
//        presentingViewController?.present(queue, animated: true)
////        NotificationCenter.default.post(name: NSNotification.Name("queue"), object: nil)
//    }
}
