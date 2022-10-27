//
//  ReleasesViewController.swift
//  Ample
//
//  Created by bajo on 2022-10-15.
//

import UIKit

class ReleasesViewController: UIViewController {

    private var tableView: UITableView!
    private var data: [LibItem] = []
    
    private let user = UserDefaults.standard.value(forKey: "user")!
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "New Releases for you"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let item = LibItem(id: "92429d82a41e930486c6de5ebda9602d55c39986", trackNum: nil, genre: nil, type: "Podcast", title: "New Rory and Mal", artistId: "89a8e9e5ab379b3f244c8f2e8776b5a142757636", posterImage: nil, tagline: nil, artist: "New Rory and Mal", name: nil, imageURL: "rnm", audioURL: nil, albumId: nil, playCount: nil, subscribers: nil, isVerified: nil, joinDate: nil, videoURL: nil, posterURL: nil)
//
//        data.append(item)
        
        NetworkManager.Get(url: "home/releases?user=\(user)") { (data: [LibItem]?, err: NetworkError) in
            
            switch(err){
            case .notfound:
                print("Not found")
            case .servererr:
                print("Internal srver err")
            case .success:
                
                self.data = data!
                DispatchQueue.main.async{
                    self.setupView()
                }
                
            }
        }
            
        
    }
    
    private func setupView(){
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.register(ReleasesSectionCell.self, forCellReuseIdentifier: ReleasesSectionCell.reuseIdentifier)
        
        view.addSubview(tableView)
    }
    
}

extension ReleasesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = ReleaseSectionHeaderView()
        sectionHeader.setupHeader(item: data[section])
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReleasesSectionCell.reuseIdentifier, for: indexPath) as! ReleasesSectionCell
        cell.configureCell(item: data[indexPath.row])
        return cell
    }
}

class ReleaseSectionHeaderView: UIView {
    
    var labelStack: UIStackView!
    
    
    private let headerImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
//        view.backgroundColor = .white
        return view
    }()
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .label
        return label
    }()
    private let headerType: UILabel = {
        let label = UILabel()
        label.text = "type"
        label.setFont(with: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    func setupHeader(item: LibItem?){
        
//        backgroundColor  = .red
        
        headerImage.setUpImage(url: item!.imageURL!, interactable: false)
        
        addSubview(headerImage)
        
        headerType.text = item!.type
        headerTitle.text = item!.title
        
        labelStack = UIStackView(arrangedSubviews: [headerType, headerTitle])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(labelStack)
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: 60),
            
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerImage.centerYAnchor.constraint(equalTo: centerYAnchor),
//
            labelStack.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: 20),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
//
//{
//    _id: new ObjectId("6320ad494094a5732ec19d04"),
//    id: '92429d82a41e930486c6de5ebda9602d55c39986',
//    type: 'podcast',
//    title: 'New Rory & Mal Podcast',
//    artistId: '89a8e9e5ab379b3f244c8f2e8776b5a142757636',
//    imageURL: 'rnm',
//    albumId: ''
//  },


class ReleasesSectionCell: UITableViewCell {
    
    static var reuseIdentifier: String = "releaseCell"
    
    private var primaryStack: UIStackView!
    private var btnStack: UIStackView!
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.layer.cornerRadius = 10
//        view.backgroundColor = .red
        return view
    }()
    
    private let imageContainer: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .secondaryLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    private let itemType: UILabel = {
        let label = UILabel()
        label.text = "Single"
        label.setFont(with: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track name"
        label.textColor = .label
        label.setBoldFont(with: 20)
        return label
    }()
    private let playBtn: UIButton = {
        let btn = configBtn(size: 30, image: "play.circle.fill")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
    private let optionsBtn: UIButton = {
        let btn = configBtn(size: 20, image: "ellipsis")
        btn.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        return btn
    }()
//
    func configureCell(item: LibItem){
        
        backgroundColor = .clear
        
        addSubview(containerView)
        
        imageContainer.setUpImage(url: item.imageURL!, interactable: false)
        
        addSubview(imageContainer)
        
        btnStack = UIStackView(arrangedSubviews: [optionsBtn, playBtn])
        btnStack.axis = .horizontal
        btnStack.distribution = .equalSpacing
        btnStack.translatesAutoresizingMaskIntoConstraints = false
        btnStack.alignment = .center
        
        
        addSubview(btnStack)
        
        itemType.text = item.type!
        titleLabel.text = item.title!
        
        primaryStack = UIStackView(arrangedSubviews: [itemType, titleLabel])
        primaryStack.axis = .vertical
        primaryStack.alignment = .leading
        primaryStack.spacing = 5
        primaryStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(primaryStack)
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: 200),
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
//            imageContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
//            imageContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            imageContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 150),
            imageContainer.heightAnchor.constraint(equalToConstant: 150),
            
            primaryStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            primaryStack.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 20),
            primaryStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            btnStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            btnStack.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 20),
            btnStack.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
            
        ])
        
    }
    
    override func layoutSubviews() {
        addGradientLayer()
    }
    
    private func addGradientLayer(){
        
        let currentColor = imageContainer.image?.averageColor?.cgColor
//        backgroundColor = currentColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [currentColor, UIColor.black.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = containerView.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0 )
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    
        containerView.layer.addSublayer(gradientLayer)
    }
    
    
}
