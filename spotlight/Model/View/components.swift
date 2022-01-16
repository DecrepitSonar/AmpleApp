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
        imgView.setUpImage(url: img)
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

class MiniPlayer: UIView {
    
    var timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setTrack(sender:)), name: Notification.Name("trackChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(togglePlayBtn), name: NSNotification.Name("isPlaying"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMiniPlayer), name: NSNotification.Name("update"), object: nil)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPlayer)))
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.1).cgColor
        layer.cornerRadius = 5
        addSubview(img)
        
        trackLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let trackInfoStack = UIStackView(arrangedSubviews: [artistLabel, trackLabel])
        trackInfoStack.axis = .vertical
        trackInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(trackInfoStack)
        
        let buttonStack = UIStackView(arrangedSubviews: [playBtn, playNext])
        buttonStack.axis = .horizontal
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 20
        
        addSubview(buttonStack)

        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            heightAnchor.constraint(equalToConstant: 70),
            
            img.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            img.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            trackInfoStack.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 20),
            trackInfoStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    @objc func setTrack(sender: Notification){
        
        if let object = sender.userInfo as NSDictionary? {
            if let track = object["track"] {
                
                NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : track])
                
                AudioManager.initPlayer(track: track as? Track, tracks: nil)
                return 
            }
        }
    }
    
    @objc func updateMiniPlayer(sender: Notification){

        
        if let object = sender.userInfo as NSDictionary? {
                  if let track = object["track"]{
                      let track = track as? Track
                      
                      img.setUpImage(url: track!.imageURL)
                      artistLabel.text = track!.name
                      trackLabel.text = track!.title
                  }
        }

//        if let object = sender.userInfo as NSDictionary? {
//            if let id = object["track"]{
//
//                NetworkManager.getTrack( id: id as! String, completion: {
//                    result in
//
//                    switch( result){
//                    case .success( let data):
//                        self.img.image = UIImage(named: data.imageURL)
//                        self.artistLabel.text = data.name
//                        self.trackLabel.text = data.title
//
//                    case .failure( let err):
//                        print(err)
//                    }
//                })
//
//            }
//        }
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
    @objc func togglePlayState(){
        guard player != nil else {
            return
        }
        if(player!.isPlaying && player! != nil){
            AudioManager.playerController(option: .pause )
            
        } else {
            AudioManager.playerController(option: .resume)
            
        }
        
        
        
        
        print("pressed")
        NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
    }
    @objc func openPlayer(){
        print("pressed")
        NotificationCenter.default.post(name: NSNotification.Name("player"), object: nil)
    }
   
    let img: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "6lack")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.clipsToBounds = true
//        view.layer.cornerRadius = 5
        
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
class customTab: UITabBarController{
    
    
    let animate = CABasicAnimation()

    let miniPlayer = MiniPlayer()
    let player = MiniPlayer()
    
    override func viewDidLoad() {
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        
        view.addSubview(miniPlayer)
        
        miniPlayer.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10).isActive = true
        miniPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let homeVc = UINavigationController(rootViewController: MusicViewController())
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let musicVc = UINavigationController(rootViewController: MusicViewController())
        musicVc.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "waveform.path.ecg"), tag: 1)
        
        let videoVc = UINavigationController(rootViewController: VideoViewController())
        videoVc.tabBarItem = UITabBarItem(title: "Video", image: UIImage(systemName: "play.tv"), tag: 2)
        
        let searchVc = UINavigationController(rootViewController: SearchViewController())
        searchVc.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
                                           
        let library = UINavigationController(rootViewController: Library())
        library.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "books.vertical"), tag: 4)
        
        tabBar.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        
        tabBar.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
    
        tabBar.frame = CGRect(x: 100, y: 100, width: 200, height: 200)

        self.viewControllers = [homeVc, searchVc, library]
    
    }

}
