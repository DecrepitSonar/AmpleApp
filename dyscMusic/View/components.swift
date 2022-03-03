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
//        imgView.setUpImage(url: img)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(togglePlayBtn), name: NSNotification.Name("isPlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMiniPlayer), name: NSNotification.Name("update"), object: nil)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPlayer)))
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        container.addSubview(img)
        
        trackLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let trackInfoStack = UIStackView(arrangedSubviews: [trackLabel, artistLabel])
        trackInfoStack.axis = .vertical
        trackInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(trackInfoStack)
        
        addSubview(playBtn)

        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            heightAnchor.constraint(equalToConstant: 70),
            
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            img.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            img.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            playBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            playBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            trackInfoStack.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 20),
            trackInfoStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        self.isHidden = true
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
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.1).cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    let img: UIImageView = {
        
        let view = UIImageView()
        view.image = UIImage(named: "6lack")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.clipsToBounds = true
        
        return view
        
    }()
    let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "6lack"
        label.textColor = .secondaryLabel
        label.setFont(with: 10)
        return label
        
    }()
    let trackLabel: UILabel = {
        let label = UILabel()
        label.text = "Nonchallant"
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
class customTab: UITabBarController, PlayerDelegate, AVAudioPlayerDelegate{
    
    let animate = CABasicAnimation()

    let miniPlayer = MiniPlayer()
    
    override func viewDidLoad() {
        
        miniPlayer.delegate = self
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        
        view.addSubview(miniPlayer)
        
        miniPlayer.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10).isActive = true
        miniPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func openPlayer() {
        let player = PlayerViewController()
        print("opening player")
           
        print("presenting player")
        player.modalPresentationStyle = .overFullScreen
        self.selectedViewController?.present(player, animated: true)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let browse = UINavigationController(rootViewController: MusicViewController())
        browse.tabBarItem = UITabBarItem(title: "Browse",
                                         image: UIImage(systemName: "globe.americas.fill"),
                                         tag: 0)
        
        let searchVc = UINavigationController(rootViewController: SearchViewController())
        searchVc.tabBarItem = UITabBarItem(title: "Search",
                                           image: UIImage(systemName: "magnifyingglass"),
                                           tag: 3)
                                           
        let library = UINavigationController(rootViewController: Library())
        library.tabBarItem = UITabBarItem(title: "Library",
                                          image: UIImage(systemName: "books.vertical"),
                                          tag: 4)
        
        tabBar.tintColor = UIColor.init(displayP3Red: 255 / 255,
                                        green: 227 / 255,
                                        blue: 77 / 255,
                                        alpha: 0.5)
        
        tabBar.backgroundColor = UIColor.init(displayP3Red: 22 / 255,
                                              green: 22 / 255,
                                              blue: 22 / 255,
                                              alpha: 1)
    
        tabBar.frame = CGRect(x: 100, y: 100, width: 200, height: 200)

        self.viewControllers = [library, browse, searchVc]
    
    }

}
