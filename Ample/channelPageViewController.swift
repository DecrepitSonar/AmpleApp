//
//  channelPageViewController.swift
//  Ample
//
//  Created by bajo on 2022-09-15.
//

import UIKit

class channelPageViewController: UIViewController {

    var channelId: String?
    var channel: Channel!
    var episodes: [Episodes]!
    
    private var tableView: UITableView!
    private var header: channelHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false 
        NetworkManager.Get(url: "channel?id=\(channelId!)") { (result: Channel?, err: NetworkError) in
            
            switch( err){
            case .notfound:
                print("not found")
            case .servererr:
                print("internal server err")
            case .success:
                self.channel = result!
                self.episodes = result?.episodes
                DispatchQueue.main.async {
                    self.configureTableView()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        tableView = UITableView(frame: view.bounds)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        header = channelHeader(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        header.config(channel: channel)
        tableView.tableHeaderView = header
        
        view.addSubview(tableView)
    }

}
extension channelPageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Episodes"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier) as! EpisodeCell
        cell.configView(item: episodes[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
    
    
}

class channelHeader: UIView{
    
    var blurr: UIBlurEffect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        blurr = UIBlurEffect(style: .dark )
        let visualView = UIVisualEffectView(effect: blurr)
        addSubview(bannerContainer)
        bannerContainer.addSubview(banner)
        bannerContainer.addSubview(visualView)

        visualView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: frame.height)

        addSubview(image)
        addSubview(title)
        addSubview(channelDescription)
        
        let followbtnStack = UIStackView(arrangedSubviews: [followBtn, optionsEllipsis])
        followbtnStack.axis = .horizontal
        followbtnStack.translatesAutoresizingMaskIntoConstraints = false
        followbtnStack.spacing = 20
        
        addSubview(followbtnStack)
        
        let seperator = UIView()
        seperator.backgroundColor = .tertiaryLabel
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(seperator)
        
        let buttonStack = UIStackView(arrangedSubviews: [queueBtn, saveBtn, downloadBtn, playbtn])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
//        addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            bannerContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bannerContainer.topAnchor.constraint(equalTo: topAnchor),
            bannerContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bannerContainer.heightAnchor.constraint(equalToConstant: 190),
            
            image.leadingAnchor.constraint(equalTo: bannerContainer.leadingAnchor, constant: 20),
            image.topAnchor.constraint(equalTo: bannerContainer.topAnchor, constant: 20),
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150),
            
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: bannerContainer.trailingAnchor, constant: -20),
            title.topAnchor.constraint(equalTo: image.topAnchor),
            
            channelDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            channelDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            channelDescription.topAnchor.constraint(equalTo: bannerContainer.bottomAnchor, constant: 10),
        
            followbtnStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            followbtnStack.topAnchor.constraint(equalTo: channelDescription.bottomAnchor, constant: 10),
    
//            seperator.topAnchor.constraint(equalTo: followbtnStack.bottomAnchor, constant: 20),
//            seperator.widthAnchor.constraint(equalToConstant: bounds.width / 2),
//            seperator.heightAnchor.constraint(equalToConstant: 0.5),
            
//            buttonStack.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 20),
//            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func config(channel: Channel){
        banner.setUpImage(url: channel.imageURL, interactable: false)
        image.setUpImage(url: channel.imageURL, interactable: false)
        backgroundColor = image.image?.averageColor
        title.text = channel.name
        channelDescription.text = channel.description
    }
    
    let bannerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    let banner: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        return img
    }()
    
    let followBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1), for: .normal)
        btn.setTitle("Subscribe", for: .normal)
        btn.layer.borderColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1).cgColor
        btn.layer.cornerRadius = 5
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.titleLabel?.setFont(with: 12)
        btn.layer.borderWidth = 1
        return btn
    }()
    
    let optionsEllipsis: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        btn.setTitleColor(UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1), for: .normal)
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    
    
    let title: UILabel = {
        let label = UILabel()
        label.setFont(with: 30)
        label.numberOfLines  = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playbtn: UIButton = {
        let btn = configBtn(size: 40, image: "play.circle.fill")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let queueBtn: UIButton = {
        let btn = configBtn(size: 20, image: "list.triangle")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let saveBtn: UIButton = {
        let btn = configBtn(size: 20, image: "heart.fill")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let downloadBtn: UIButton = {
        let btn = configBtn(size: 20, image: "arrow.down.circle")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)

        return btn
    }()
    let shareBtn: UIButton = {
        let btn = configBtn(size: 20, image: "")
        btn.setImage(UIImage(systemName: ""), for: .normal)
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let channelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.setFont(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        return label
    }()
}

func configBtn(size: Double, image: String) -> UIButton {
    let btn = UIButton()
    btn.setSystemImageWithConfigureation(systemImage: image, size: size)
    return btn
    
}

class EpisodeCell: UITableViewCell {
        
    static let reuseIdentifier: String = "episodeCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .tertiaryLabel
        
        clipsToBounds = true
        addSubview(image)
        
        let buttonStack = UIStackView(arrangedSubviews: [optionsEllipsis, playBtn ])
        buttonStack.spacing = 20
        buttonStack.alignment = .trailing
        buttonStack.distribution = .equalSpacing
        buttonStack.axis = .horizontal
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
//
        addSubview(buttonStack)
        
        let contentDescriptionStack = UIStackView(arrangedSubviews: [title, episodeDescription])
        contentDescriptionStack.axis = .vertical
        contentDescriptionStack.distribution = .fillProportionally
        contentDescriptionStack.spacing = 5
        contentDescriptionStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentDescriptionStack)
        
        addSubview(seperator)
        
//        addSubview(container)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 150),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            image.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            contentDescriptionStack.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            contentDescriptionStack.topAnchor.constraint(equalTo: image.topAnchor),
            contentDescriptionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            buttonStack.trailingAnchor.constraint(equalTo: contentDescriptionStack.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: contentDescriptionStack.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: contentDescriptionStack.leadingAnchor),
            
//            seperator.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor),
            seperator.leadingAnchor.constraint(equalTo: contentDescriptionStack.leadingAnchor),
            seperator.heightAnchor.constraint(equalToConstant: 0.5),
            seperator.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            
//            container.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 20),
//            container.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
//            container.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            
        ])
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configView(item: Episodes){
        image.setUpImage(url: item.imageURL, interactable: false)
        title.text = item.name
        episodeDescription.text = item.description
        container.setUpImage(url: item.video!.posterURL!, interactable: true)
    }
    
    let playBtn: UIButton = {
        let btn =  configBtn(size: 30, image: "play.circle.fill")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let saveBtn: UIButton = {
        let btn = configBtn(size: 20, image: "heart.fill")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    let downloadBtn: UIButton = {
        let btn = configBtn(size: 20, image: "arrow.down.circle")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)

        return btn
    }()
    let image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    let optionsEllipsis: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        btn.setTitleColor(UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1), for: .normal)
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return btn
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "title"
        return label
    }()
    
    let episodeDescription: UILabel = {
        let label = UILabel()
        label.text = "This is a description of the episode"
        label.numberOfLines = 5
        label.setFont(with: 11)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let container: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
