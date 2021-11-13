////
////  components.swift
////  spotlight
////
////  Created by Robert Aubow on 6/18/21.
////
//
import Foundation
import UIKit
import AudioToolbox

class AViCard: UIView {

    let imgView = UIImageView()
    let label = UILabel()

    override init(frame: CGRect){
        super.init(frame: frame)
//
    }

    required init?(coder: NSCoder){
        fatalError("")
    }

    func configureCard(img: String, name: String){
        setupImg(img: img)
        setupLabel(name: name)
    }
    func setupImg(img: String){
        imgView.image = UIImage(named: img)
        imgView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imgView.layer.cornerRadius = 35
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill

        // add image to view
        self.addSubview(imgView)

        // configure constraints
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true

    }
    func setupLabel(name: String){
        label.text = name
        label.textColor = .label
        label.setFont(with: 12)

        // add label
        self.addSubview(label)

        // configure constraints
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
} // User avitar image

// Buttons
class LargePrimaryButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setupButton(label: String){
        self.setTitle(label, for: .normal)
        self.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
    }
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
//
//// Extentions
extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
//        backgroundColor = .white
//        textColor = .black
        bottomLine.cornerRadius = 25
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
extension UILabel {
    func setFont(with size: CGFloat){
        font = UIFont(name: "Helvetica Neue", size: size)
    }
    func setBoldFont(with size: CGFloat){
        font = UIFont.boldSystemFont(ofSize: size)
    }
}

class LargePlayer: UIView {
    
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
    
    let player = MiniPlayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
//
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        addSubview(effect)
        effect.frame = self.frame
        
//        addSubview(player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayer(_sender:)), name: Notification.Name("trackChange"), object: nil)
        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)

        image.image = UIImage(named: "6lack")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        addSubview(image)
        
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
        playBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
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
        
        addSubview(stackControls)
        
        closeBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closePlayer), for: .touchUpInside)
        closeBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        addSubview(closeBtn)
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
            
//            player.topAnchor.constraint(equalTo: topAnchor, constant: 75),
//            player.centerXAnchor.constraint(equalTo: centerXAnchor),
//            
    
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 320),
            image.widthAnchor.constraint(equalToConstant: 340),
            
            
            slider.widthAnchor.constraint(equalToConstant:  250),
            slider.heightAnchor.constraint(equalToConstant: 10),
            
            stackControls.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackControls.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            image.bottomAnchor.constraint(equalTo: stackControls.topAnchor, constant: -50),
            
            closeBtn.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            closeBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
//
        ])
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    @objc func closePlayer(){
//        animator.fractionComplete = 1
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
class MiniPlayer: UIView {
    
    var timer = Timer()
    let img: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "6lack")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let artistLabel = UILabel()
    let trackLabel = UILabel()

    let playBtn = UIButton()
    let playNext = UIButton()
    let prevBtn = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setTrack(sender:)), name: Notification.Name("trackChange"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(togglePlayBtn), name: NSNotification.Name("isPlaying"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMiniPlayer), name: Notification.Name("update"), object: nil)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.1).cgColor
        
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(img)
        
        artistLabel.text = "6lack"
        artistLabel.textColor = .secondaryLabel
        artistLabel.setFont(with: 10)
        
        trackLabel.text = "Nonchallant"
        trackLabel.textColor = .label
        trackLabel.setFont(with: 12)
        
        trackLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let trackInfoStack = UIStackView(arrangedSubviews: [artistLabel, trackLabel])
        trackInfoStack.axis = .vertical
        trackInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(trackInfoStack)
        
        prevBtn.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        prevBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playBtn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        playBtn.addTarget(self, action: #selector(togglePlayState), for: .touchUpInside)
        
        playNext.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        playNext.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        playNext.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [playBtn, playNext])
        buttonStack.axis = .horizontal
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 20
        
        addSubview(buttonStack)
        
        layer.cornerRadius = 10
        
        img.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        img.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        img.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        trackInfoStack.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 20).isActive = true
        trackInfoStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    @objc func setTrack(sender: Notification){
        
        if let object = sender.userInfo as NSDictionary? {
            if let track = object["track"] {
                
                NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : track])
                
                AudioManager.initPlayer(track: track as? String, tracks: nil)
            }
        }
    }
    
    @objc func updateMiniPlayer(sender: Notification){

        if let object = sender.userInfo as NSDictionary? {
            if let id = object["track"]{
                
                NetworkManager.getTrack( id: id as! String, completion: {
                    result in

                    switch( result){
                    case .success( let data):
                        self.img.image = UIImage(named: data.imageURL)
                        self.artistLabel.text = data.name
                        self.trackLabel.text = data.title
                        
                    case .failure( let err):
                        print(err)
                    }
                })
                
            }
        }
    }
    
    @objc func nextTrack(){
        AudioManager.playerController(option: .next)
        
    }
    
    @objc func togglePlayBtn(sender: Notification){
    
        if (player!.isPlaying){
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        }else{
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func setPlayerInterval(){
        print(Int(player!.currentTime))
        if(player?.currentTime == player?.duration){
            
        }
    }
    
    @objc func togglePlayState(){
        if(player!.isPlaying){
            AudioManager.playerController(option: .pause ) } else{ AudioManager.playerController(option: .resume)}
        print("pressed")
        NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
    }
    
   
    
}
class customTab: UITabBarController{
    
    
    let animate = CABasicAnimation()
    
    var tapgesture: CustomGestureRecognizer!
    let miniPlayer = MiniPlayer()
    var playerContainer =  LargePlayer()
    
    override func viewDidLoad() {
        
        tabBar.frame.origin.y = 500
        // initialize playerContainer
        
//        playerContainer.addSubview(miniPlayer)
//        miniPlayer.topAnchor.constraint(equalTo: playerContainer.topAnchor, constant: 100).isActive = true
//        miniPlayer.centerXAnchor.constraint(equalTo: playerContainer.centerXAnchor).isActive = true

//        playerContainer.layer.opacity = 0
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        
//        tapgesture = CustomGestureRecognizer(target: self, action: #selector(animatePlayer))
        
//        player.addGestureRecognizer(tapgesture)
        
//        tabBar.layer.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: 200)
        
        
//        tabBar.layer.zPosition = 2
                              
        view.addSubview(playerContainer)

        
//        playerContainer.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10).isActive = true
//        playerContainer.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 10).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let homeVc = UINavigationController(rootViewController: ViewController())
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            
        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 0)
        tabBar.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        tabBar.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
    
        tabBar.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        //setViewControllers([homeVc, profile], animated: true)

        self.viewControllers = [homeVc, profile]
    
    }
    
    @objc func openPlayer(){
   
        animate.keyPath = "position.y"
        animate.fromValue = UIScreen.main.bounds.height - (self.tabBar.bounds.height - 10)
        animate.toValue = 200
        animate.duration = 0.5

        playerContainer.layer.add(animate, forKey: "basic")
        playerContainer.layer.position = CGPoint(x: (UIScreen.main.bounds.width / 2), y: 200)
        
        print("player tapped")
    }
    
    @objc func closePlayer(){
        
        animate.keyPath = "position.y"
        animate.fromValue = 0
        animate.toValue = CGFloat(UIScreen.main.bounds.height - (self.tabBar.bounds.height - 10))
        animate.duration = 0.5

        playerContainer.layer.add(animate, forKey: "basic")
        playerContainer.layer.position = CGPoint(x: (UIScreen.main.bounds.width / 2), y: 200)
        
    }
    
}
