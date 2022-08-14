////
////  components.swift
////  spotlight
////
////  Created by Robert Aubow on 6/18/21.
////

import Foundation
import UIKit
import AudioToolbox
import AVFAudio

protocol CellComponent {
    
}
class AViCard: UIView, CellComponent {

    let imgView = UIImageView()
    let label = UILabel()

    override init(frame: CGRect){
        super.init(frame: frame)
//        backgroundColor = .yellow
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
        imgView.setUpImage(url: img, interactable: true)
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
        imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

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
        self.layer.cornerRadius = 8
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

class MiniPlayer: UIView, AVAudioPlayerDelegate {
    
    let player = AudioManager.shared.player
    let audioManager = AudioManager.shared
    
    var timer = Timer()
    var delegate: PlayerDelegate?
    
    let blurrEffect = UIBlurEffect(style: .dark)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let visualEffect = UIVisualEffectView(effect: blurrEffect)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(visualEffect)
        
//        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(togglePlayBtn),
                                               name: NSNotification.Name("isPlaying"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateMiniPlayer),
                                               name: NSNotification.Name("update"),
                                               object: nil)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPlayer)))
//        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        addSubview(img)
        
        let trackInfoStack = UIStackView(arrangedSubviews: [trackLabel, artistLabel])
        trackInfoStack.axis = .vertical
        trackInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(trackInfoStack)
        
        addSubview(playBtn)
        addSubview(progressView)

        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            heightAnchor.constraint(equalToConstant: 70),
            
            visualEffect.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffect.topAnchor.constraint(equalTo: topAnchor),
            visualEffect.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffect.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            trackLabel.widthAnchor.constraint(equalToConstant: 120),
            
            img.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            img.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            playBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            playBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            trackInfoStack.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 20),
            trackInfoStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
//        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }

    @objc func updateMiniPlayer(sender: Notification){
        
        
        NetworkManager.getImage(with: self.audioManager.currentQueue!.imageURL) { result in
            switch(result){
            case .success(let data):
                
                DispatchQueue.main.async {
                    self.isHidden = false
                    self.img.image = UIImage(data: data)
                    self.artistLabel.text = self.audioManager.currentQueue!.name
                    self.trackLabel.text = self.audioManager.currentQueue!.title
                    self.backgroundColor = self.img.image?.averageColor
                    
                    self.superview
                }
                
            case .failure(let err):
                print(err)
                return
            }
        }
        
       
        
    }
    @objc func nextTrack(){
        audioManager.playerController(option: .next)
        
    }
    @objc func togglePlayBtn(sender: Notification){
        
        if (audioManager.player.isPlaying){
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            
        }else{
            DispatchQueue.main.async {
                self.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
    @objc func togglePlayState(){
        
        if(audioManager.player.isPlaying && audioManager.player != nil){
            audioManager.playerController(option: .pause)
        }
        else{
            audioManager.playerController(option: .resume)
        }
    }
    @objc func openPlayer(){
        print("pressed player")
        
        delegate?.openPlayer()
    }
   
    let container: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.1).cgColor
//        view.layer.cornerRadius = 5
        return view
    }()
    let progressView: UIProgressView = {
        let view = UIProgressView()
        return view
    }()
    let img: UIImageView = {
        
        let view = UIImageView()
        view.image = UIImage(named: "default track artwork")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        
        return view
        
    }()
    let artistLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .secondaryLabel
        label.setFont(with: 10)
        return label
        
    }()
    let trackLabel: UILabel = {
        let label = UILabel()
        label.text = "No Track selected"
        label.textColor = .label
        label.setFont(with: 12)
        return label
    }()
    let playBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(togglePlayState), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let playNext: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        
        return btn
    }()
    let prevBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        return btn
    }()
    
}
class customTab: UITabBarController, PlayerDelegate, AVAudioPlayerDelegate {

    
    let miniPlayer = MiniPlayer()
    
    var miniPlayerHeight: CGFloat = 70
    var miniPlayerBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        miniPlayer.delegate = self
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        
        view.addSubview(miniPlayer)
    
        miniPlayer.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -70).isActive = true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
     
    func openPlayer() {
        
        let player = UINavigationController(rootViewController: PlayerViewController())
        print("opening player")
           
        print("presenting player")
        player.modalPresentationStyle = .overFullScreen
        self.selectedViewController?.present(player, animated: true)
        
        let openingAnimation = UIViewPropertyAnimator(duration: 0.7, curve: .easeOut) {
            
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let music = UINavigationController(rootViewController: HomeViewController())
        music.tabBarItem = UITabBarItem(title: "Music",
                                         image: UIImage(systemName: "hifispeaker.2"),
                                         tag: 0)
        
        let videos = UINavigationController(rootViewController: SearchViewController())
        videos.tabBarItem = UITabBarItem(title: "Videos",
                                         image: UIImage(systemName: "magnifyingglass"),
                                         tag: 0)

        let library = UINavigationController(rootViewController: LibraryViewController())
        library.tabBarItem = UITabBarItem(title: "Library",
                                          image: UIImage(systemName: "books.vertical"),
                                          tag: 2)
        
        tabBar.tintColor = UIColor.init(displayP3Red: 255 / 255,
                                        green: 227 / 255,
                                        blue: 77 / 255,
                                        alpha: 0.5)
//
//        tabBar.backgroundColor = UIColor.init(displayP3Red: 22 / 255,
//                                              green: 22 / 255,
//                                              blue: 22 / 255,
//                                              alpha: 1)
//
//        tabBar.frame = CGRect(x: 100, y: 100, width: 200, height: 200)

        self.viewControllers = [music, videos, library]
    
    }

}
