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
    
    // Cover Art
    var coverArtHeight: CGFloat = 340
    var coverArtWidth: CGFloat = 340
    var coverArtYAnchor: CGFloat = -150
    var coverArtXAnchor: CGFloat = 0
    
    var coverArtHeightConstraint: NSLayoutConstraint?
    var coverArtWidthConstraint: NSLayoutConstraint?
    var coverArtYAxisContraint: NSLayoutConstraint?
    var coverArtXAxistConstraint: NSLayoutConstraint?
    
    // Track Label
    var buttonStack: UIStackView!
    var labelStackLeadingAnchor: CGFloat = 20
    var labelStackWidth: CGFloat = 250
    var labelStackHeight: CGFloat = 100
    var labelStackYAxisAnchor: CGFloat = 100
    var labelStackXAxisAnchor: CGFloat = 0
    
    var labelStackYAxisConstraint: NSLayoutConstraint?
    var labelStackXAxisConstraint: NSLayoutConstraint?
    var labelStackWidthConstraint: NSLayoutConstraint?
    var labelStackHeightConstraint: NSLayoutConstraint?
    
    // Control Buttons
    var labelStack: UIStackView!
    var buttonStackLeadingAnchor: CGFloat = 20
    var buttonStackWidth: CGFloat = 250
    var buttonStackHeight: CGFloat = 100
    var buttonTopAnchor: CGFloat = 50
    var buttonXAxisAnchor: CGFloat = 0
    
    var buttonTopConstraint: NSLayoutConstraint?
    var buttonXAxisConstraint: NSLayoutConstraint?
    var buttonStackWidthConstraint: NSLayoutConstraint?
    var buttonStackHeightConstraint: NSLayoutConstraint?
    
    // Slider
    var sliderStack: UIStackView!
    var sliderStackTopAnchor: CGFloat = 50
    var sliderStackWidth: CGFloat = 250
    var sliderStackHeight: CGFloat = 100
    var sliderStackXAxisAnchor: CGFloat = 0
    
    var sliderStackTopConstraint: NSLayoutConstraint?
    var sliderStackXAxisConstraint: NSLayoutConstraint?
    var sliderStackWidthConstraint: NSLayoutConstraint?
    var sliderStackHeightConstraint: NSLayoutConstraint?
    
    // Queue container
    let queueView = TrackQueueListViewController()
    
    var queueHeightAnchor: CGFloat = 0
    var queueHeightConstraint: NSLayoutConstraint?
    var queueIsOpen: Bool = false
    

//    let track = Track(id: "49f25741ff0db65a7c4290aa73f34b4d4a3644c6",
//                      type: nil,
//                      trackNum: nil,
//                      title: "Solo",
//                      artistId: "6c1d77a1851c78aa2894f8b7be3f7af4",
//                      name: "Frank Ocean",
//                      imageURL: "457391c9c82bfdcbb4947278c0401e41",
//                      albumId: "457391c9c82bfdcbb4947278c0401e41",
//                      audioURL: "49f25741ff0db65a7c4290aa73f34b4d4a3644c6",
//                      playCount: 2312,
//                      videoId: nil)
    
    override open var shouldAutorotate: Bool { return false }
    
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
        image.layer.zPosition = 5
        
        trackTitle.text = "Track Title"
        artist.text = "Artist"
        
        labelStack = UIStackView(arrangedSubviews: [trackTitle, artist])
        labelStack.axis = .vertical
        labelStack.distribution = .equalCentering
        labelStack.spacing = 5
        labelStack.alignment = .center
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack = UIStackView(arrangedSubviews: [prevBtn, playBtn, forwardBtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(labelStack)
        view.addSubview(buttonStack)
        
        let timerStack = UIStackView(arrangedSubviews: [ totalTimeLapsed, totalTrackTime ])
        timerStack.axis = .horizontal
        timerStack.spacing = 5
        timerStack.distribution = .equalSpacing

        sliderStack = UIStackView(arrangedSubviews: [slider, timerStack ])
        sliderStack.axis = .vertical
        sliderStack.spacing = 8
        sliderStack.distribution = .equalSpacing
        sliderStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(sliderStack)
        view.addSubview(likeBtn)
        view.addSubview(queue)
        view.addSubview(QueueContainer)
        
        addChild(queueView)
        
        QueueContainer.addSubview( queueView.view)
        queueView.view.frame = QueueContainer.bounds
        
        NSLayoutConstraint.activate([
            

            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            likeBtn.trailingAnchor.constraint(equalTo: sliderStack.trailingAnchor),
            likeBtn.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 20),
            
            queue.leadingAnchor.constraint(equalTo: sliderStack.leadingAnchor),
            queue.topAnchor.constraint(equalTo: sliderStack.bottomAnchor, constant: 20),
            
            QueueContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
        // Cover Art
        coverArtHeightConstraint = image.heightAnchor.constraint(equalToConstant: coverArtHeight)
        coverArtHeightConstraint?.isActive = true
        
        coverArtYAxisContraint = image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: coverArtYAnchor)
        coverArtYAxisContraint?.isActive = true
        
        coverArtXAxistConstraint = image.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        coverArtXAxistConstraint?.isActive = true
        
        coverArtWidthConstraint = image.widthAnchor.constraint(equalToConstant: coverArtWidth)
        coverArtWidthConstraint?.isActive = true
        
        // Track Label
        labelStackYAxisConstraint = labelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: labelStackYAxisAnchor)
        labelStackYAxisConstraint?.isActive = true
        
        labelStackXAxisConstraint = labelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        labelStackXAxisConstraint?.isActive = true
        
        labelStackWidthConstraint = labelStack.widthAnchor.constraint(equalToConstant: labelStackWidth)
        labelStackWidthConstraint?.isActive = true
        
        // Button Controls
        buttonTopConstraint = buttonStack.topAnchor.constraint(equalTo: labelStack.bottomAnchor, constant: buttonTopAnchor)
        buttonTopConstraint?.isActive = true

        buttonXAxisConstraint = buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        buttonXAxisConstraint?.isActive = true

        buttonStackWidthConstraint = buttonStack.widthAnchor.constraint(equalToConstant: buttonStackWidth)
        buttonStackWidthConstraint?.isActive = true
        
        // Progress bar
        sliderStackTopConstraint = sliderStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: sliderStackTopAnchor)
        sliderStackTopConstraint?.isActive = true
        
        sliderStackXAxisConstraint = sliderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        sliderStackXAxisConstraint?.isActive = true
        
        sliderStackWidthConstraint = sliderStack.widthAnchor.constraint(equalToConstant: 340)
        sliderStackWidthConstraint?.isActive = true
        
        // Queue
        queueHeightConstraint = QueueContainer.heightAnchor.constraint(equalToConstant: queueHeightAnchor)
        queueHeightConstraint?.isActive = true
        QueueContainer.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        
    }
    
    func animateQueueOpen(){
        
        let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.coverArtHeightConstraint?.constant = 100
            self.coverArtWidthConstraint?.constant = 100
            self.coverArtYAxisContraint?.constant = -250
            self.coverArtXAxistConstraint?.constant = -120

            self.labelStackYAxisConstraint?.constant = -250
            self.labelStackXAxisConstraint?.constant = 80
            self.buttonTopConstraint?.constant = 90
            self.buttonStackWidthConstraint?.constant = 200
            self.labelStack.alignment = .leading
            
            self.sliderStackTopConstraint?.constant = -90
            self.view.layoutIfNeeded()
        }
        
        animation.startAnimation()
        
        let animateQueueContainer = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.queueHeightConstraint?.constant = 425
            self.view.layoutIfNeeded()
        }
        
        animateQueueContainer.startAnimation()
        
        
        let  animateButtons = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            
        }
        animateButtons.startAnimation()
    }
    
    func animateQueueClose(){
        
        let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.coverArtHeightConstraint?.constant = 340
            self.coverArtWidthConstraint?.constant = 340
            self.coverArtYAxisContraint?.constant = -150
            self.coverArtXAxistConstraint?.constant = 0

            self.labelStackYAxisConstraint?.constant = 100
            self.labelStackXAxisConstraint?.constant = 0
            self.labelStack.alignment = .center
    
            self.buttonTopConstraint?.constant = 50
            self.buttonStackWidthConstraint?.constant = 250
            
            self.sliderStackTopConstraint?.constant = 50
            self.view.layoutIfNeeded()
        }
        
        animation.startAnimation()
        
        let animateQueueContainer = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.queueHeightConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
        
        animateQueueContainer.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewWillLayoutSubviews() {
        
        var attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15)!]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        if(audioManager.currentQueue != nil){
            
            image.setUpImage(url: audioManager.currentQueue!.imageURL, interactable: false)
            
            artist.text = audioManager.currentQueue!.name
            
            trackTitle.text = audioManager.currentQueue!.title
            
            guard audioManager.player != nil else {
                return
            }
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
        
        effect.frame = view.bounds

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
    
        guard audioManager.player != nil else {
            return
        }
        
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
        guard self.audioManager.player != nil else {
            return
        }
        if( audioManager.currentQueue != nil){
            DispatchQueue.main.async {

                self.totalTimeLapsed.text = self.formatter.string(from: self.audioManager.player.currentTime )
                self.totalTrackTime.text = self.formatter.string(from: self.audioManager.player.currentTime - self.audioManager.player.duration)
            }
        }
        
    }
    @objc func toggleQueue(){
        
        var queueImag: UIImage!
        var playBtnImage: UIImage!
        
//        let view = TrackQueueListViewController()
//        view.queue = audioManager.getAudioQueue()
//
//        print("queue")
//        present(view, animated: true)
        
        if( queueIsOpen){
            animateQueueClose()
            queueImag = UIImage(systemName: "list.number", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
            queueIsOpen = false
            
            playBtnImage = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 40))
                               
        }else{
            animateQueueOpen()
            queueImag = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20))
            queueIsOpen = true
            
            playBtnImage = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 15))
        }
        
        DispatchQueue.main.async {
            self.queue.setImage(queueImag, for: .normal)
            self.playBtn.setImage(playBtnImage, for: .normal)
            
            self.queue.layoutIfNeeded()
        }
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
        img.layer.masksToBounds = true
        img.image = UIImage(named: "default track artwork")
        return img
    }()
    let totalTrackTime: UILabel = {
        let label = UILabel()
        label.setFont(with: 15)
        label.text = "0:00"
        
        return label
    }()
    let totalTimeLapsed: UILabel = {
        let label = UILabel()
        label.setFont(with: 15)
        label.text = "0:00"
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
        btn.translatesAutoresizingMaskIntoConstraints = false
        
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
        label.setFont(with: 15)
        
        return label
    }()
    let trackTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "No track Selected"
        label.setFont(with: 20)
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
        
        let forwardbtnImg = UIImage(systemName: "forward.fill")!.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 30))
        
        
        let btn = UIButton()
        btn.setImage(forwardbtnImg, for: .normal)
        btn.tintColor = .label
//        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.addTarget(self, action: #selector(playnext), for: .touchUpInside)
        return btn
    }()
    let playBtn: UIButton = {
        
        let btnConfig = UIImage(systemName: "play.fill")!
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 30))
        
        let btn = UIButton()
//        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1)
        btn.tintColor = .label
        btn.addTarget(self, action: #selector(togglePlayState), for: .touchUpInside)
        btn.setImage(btnConfig, for: .normal)
        return btn
    }()
    let prevBtn: UIButton = {
        let prevbtnImg = UIImage(systemName: "backward.fill")!
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 30))
        
        let btn = UIButton()
        btn.setImage(prevbtnImg, for: .normal)
//        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.tintColor = .label
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
        btn.addTarget(self, action: #selector(toggleQueue), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
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
    
    let QueueContainer: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
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
