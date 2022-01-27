//
//  PlayerViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/20/21.
//

import UIKit
import AVFAudio

class PlayerViewController: UIViewController {
    
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
        
        navigationController?.isToolbarHidden = true
        currentTrack = AudioManager.getCurrentTrack()
        view.addSubview(effect)
        effect.frame = view.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePlayer), name: Notification.Name("update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTrackTiming), name: Notification.Name("update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(togglePlayBtn), name: NSNotification.Name("isPlaying"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
        
        timer =  Timer.scheduledTimer(timeInterval: 0.10, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
        AudioManager.setTimer(time: timer)
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)

        image.image = UIImage(named: currentTrack.imageURL)
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.cornerRadius = 10
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
        
        if( player != nil){
            player.isPlaying ? playBtn.setImage(pauseBtnImg, for: .normal) : playBtn.setImage(playbtnImg, for: .normal)
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
        artist.setFont(with: 15)
        
        trackTitle.text = currentTrack.title
        trackTitle.widthAnchor.constraint(equalToConstant: 340).isActive = true
        
        optionBtn.setImage(optionBtnImg, for: .normal)
        optionBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        shareBtn.setImage(sharebtnImg, for: .normal)
        shareBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        likeBtn.setImage(likeBtnImg, for: .normal)
        likeBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        let optionStack = UIStackView(arrangedSubviews: [likeBtn, shareBtn, optionBtn])
        optionStack.axis = .horizontal
        optionStack.alignment = .leading
        optionStack.spacing = 20
        optionStack.distribution = .equalSpacing
        
        let labelStack = UIStackView(arrangedSubviews: [artist, trackTitle])
        labelStack.axis = .vertical
        labelStack.distribution = .equalCentering
        labelStack.spacing = 10
        
        let buttonStack = UIStackView(arrangedSubviews: [shuffleBtn, prevBtn, playBtn, forwardBtn, repeatBtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillProportionally
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        slider.setThumbImage(UIImage(), for: .normal)
        slider.value = 0.3
        slider.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        totalTrackTime.setFont(with: 12)
        totalTrackTime.text = formatter.string(from: player.duration)
        
        totalTimeLapsed.setFont(with: 12)
        totalTrackTime.text = formatter.string(from: player.currentTime)
        
        if( player.currentTime > 60 ){
            self.totalTrackTime.text = self.formatter.string(from: player.duration )
            
        }else if( player.currentTime >= 10){
            self.totalTrackTime.text = "0:\(self.formatter.string(from: player.duration )!)"
            
        }else{
            self.totalTrackTime.text = "0:0\(self.formatter.string(from: player.duration )!)"
        }
        
        let sliderStack = UIStackView(arrangedSubviews: [ totalTrackTime, totalTimeLapsed])
        sliderStack.axis = .horizontal
        sliderStack.spacing = 10
        sliderStack.distribution = .equalSpacing
        
        let queueImag = UIImage(systemName: "list.number", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        queue.setImage(queueImag, for: .normal)
        queue.translatesAutoresizingMaskIntoConstraints = false
        queue.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        queue.addTarget(self, action: #selector(openQueue), for: .touchUpInside)
        
        let stackControls = UIStackView(arrangedSubviews: [optionStack, labelStack, sliderStack, slider, buttonStack, queue])
        
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
            image.heightAnchor.constraint(equalToConstant: 320),
            image.widthAnchor.constraint(equalToConstant: 340),
            
            
            slider.widthAnchor.constraint(equalToConstant:  340),
            slider.heightAnchor.constraint(equalToConstant: 10),
            
            stackControls.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackControls.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            image.bottomAnchor.constraint(equalTo: stackControls.topAnchor, constant: -50),
            
            closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
//
        ])
        
        
        
    }

    
    @objc func togglePlayState(){
//        print(slider)
        
        AudioManager.invalidateTimer()
        
        
        if(player!.isPlaying && player != nil){
            AudioManager.playerController(option: .pause)
        }
        else{
            timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
            AudioManager.setTimer(time: timer)
            AudioManager.playerController(option: .resume)
            
        }
    }
    
    @objc func playnext(){
        AudioManager.playerController(option: .next)
        timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
        AudioManager.setTimer(time: timer)
    }
    
    @objc func prev(){
        AudioManager.playerController(option: .previous)
        timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTrackTiming), userInfo: nil, repeats: true)
        AudioManager.setTimer(time: timer)
    }
    @objc func togglePlayBtn(sender: Notification){
        
        if (player!.isPlaying){
            playBtn.setImage(pauseBtnImg, for: .normal)
            
        }else{
            playBtn.setImage(playbtnImg, for: .normal)
        }
    }
    
    @objc func updateTrackTiming(){
        
        AudioManager.checkTrackIsEnded()
        
        if( player.currentTime > 60 ){
            self.totalTimeLapsed.text = self.formatter.string(from: player.currentTime )
            
        }else if( player.currentTime >= 10){
            self.totalTimeLapsed.text = "0:\(self.formatter.string(from: player.currentTime )!)"
            
        }else{
            self.totalTimeLapsed.text = "0:0\(self.formatter.string(from: player.currentTime )!)"
        }
        
//        print(round(Float(player.currentTime / player.duration)))
        slider.setValue(Float(player.currentTime / player.duration), animated: true)
        
    }
    
    
    @objc func openQueue(){
        
        let view = TrackQueueListViewController()
        view.queue = AudioManager.getAudioQueue()
        
        print("queue")
        present(view, animated: true)
                
    }
    
    @objc func closePlayer(){
        dismiss(animated: true)
        print("animator")
    }
    @objc func updatePlayer(sender: Notification){
        
        totalTrackTime.text = formatter.string(from: player.duration)
        
            AudioManager.checkTrackIsEnded()
        
//            print(player.currentTime)
            if( player.currentTime > 60){
                self.totalTimeLapsed.text = self.formatter.string(from: player.currentTime )
                
            }else if( player.currentTime >= 10){
                self.totalTimeLapsed.text = "0:\(self.formatter.string(from: player.currentTime )!)"
                
            }else{
                self.totalTimeLapsed.text = "0:0\(self.formatter.string(from: player.currentTime )!)"
            }
        
        
        if let object = sender.userInfo as NSDictionary? {
                  if let track = object["track"]{
                      let track = track as? Track

//                          print(track!.audioURL)
                      image.image = UIImage(named: track!.imageURL)
                      artist.text = track!.name
                      trackTitle.text = track!.title


                  }
        }
    //        print(_sender.userInfo?.keys)
    }

    @objc func openQueueList(){
        NotificationCenter.default.post(name: NSNotification.Name("queue"), object: nil)
    }
}
