//
//  PlayerViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/20/21.
//

import UIKit

class PlayerViewController: UIViewController {

    var collectionView: UICollectionView!
//    var datasource: UICollectionViewDiffableDataSource<Player, TrackQueue>?
    
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
    
    let forwardBtn = UIButton()
    let playBtn = UIButton()
    let prevBtn = UIButton()
    
    let shuffleBtn = UIButton()
    let repeatBtn = UIButton()
    
    let queue = UIButton()
    
    var animator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemRed
        
        view.addSubview(effect)
        effect.frame = view.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayer(_sender:)), name: Notification.Name("trackChange"), object: nil)
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)

        image.image = UIImage(named: "6lack")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        view.addSubview(image)
        
        let prevbtnImg = UIImage(systemName: "backward.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25))
        let playbtnImg = UIImage(systemName: "play.circle.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 50))
        let forwardbtnImg = UIImage(systemName: "forward.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 25))
        
        let optionBtnImg = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let sharebtnImg = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let likeBtnImg = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        let shuffleImg = UIImage(systemName: "shuffle", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        let repeatImg = UIImage(systemName: "repeat", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        
        prevBtn.setImage(prevbtnImg, for: .normal)
        prevBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        playBtn.setImage(playbtnImg, for: .normal)
        playBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        
        forwardBtn.setImage(forwardbtnImg, for: .normal)
        forwardBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        shuffleBtn.setImage(shuffleImg, for: .normal)
        shuffleBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        repeatBtn.setImage(repeatImg, for: .normal)
        repeatBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        artist.text = "6lack"
        artist.textColor = .label
        artist.setFont(with: 15)
        
        trackTitle.text = "East Atlanta Love Letter"
        
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
        labelStack.distribution = .equalSpacing
        labelStack.spacing = 10
        
        let buttonStack = UIStackView(arrangedSubviews: [shuffleBtn, prevBtn, playBtn, forwardBtn, repeatBtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillProportionally
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.value = 0.3
        slider.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        totalTrackTime.text = "3:13"
        totalTrackTime.setFont(with: 12)
        
        totalTimeLapsed.text = "0:42"
        totalTimeLapsed.setFont(with: 12)
    
        let sliderStack = UIStackView(arrangedSubviews: [ totalTrackTime, slider, totalTimeLapsed])
        sliderStack.axis = .horizontal
        sliderStack.spacing = 10
        sliderStack.distribution = .equalSpacing
        
        let queueImag = UIImage(systemName: "list.number", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
        queue.setImage(queueImag, for: .normal)
        queue.translatesAutoresizingMaskIntoConstraints = false
        queue.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        queue.addTarget(self, action: #selector(openQueueList), for: .touchUpInside)
        
        let stackControls = UIStackView(arrangedSubviews: [optionStack, labelStack, sliderStack, buttonStack, queue])
        
        stackControls.axis = .vertical
        stackControls.spacing = 25
        stackControls.distribution = .equalSpacing
        stackControls.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackControls)
//
        closeBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closePlayer), for: .touchUpInside)
        closeBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)

        view.addSubview(closeBtn)
//
//        closeBtn.layer.zPosition = 2
//        animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
//            self.layer.opacity = 1
//        })
//
//        animator.isReversed = true
//        animator.fractionComplete = 0
////
        NSLayoutConstraint.activate([

            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 320),
            image.widthAnchor.constraint(equalToConstant: 340),
            
            
            slider.widthAnchor.constraint(equalToConstant:  250),
            slider.heightAnchor.constraint(equalToConstant: 10),
            
            stackControls.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackControls.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            image.bottomAnchor.constraint(equalTo: stackControls.topAnchor, constant: -50),
            
            closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            closeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
//
        ])
        
    }
    
        @objc func closePlayer(){
            dismiss(animated: true)
            print("animator")
        }
        @objc func setPlayer(_sender: Notification){
    //        print(_sender.track!.Id)
            
            if let object = _sender.userInfo as NSDictionary? {
                if let track = object["track"] {
                    print( track)
                }
            }
    //        print(_sender.userInfo?.keys)
        }

        @objc func openQueueList(){
            NotificationCenter.default.post(name: NSNotification.Name("queue"), object: nil)
        }
}
