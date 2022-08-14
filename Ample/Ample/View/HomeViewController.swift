//
//  HomeViewController.swift
//  Ample
//
//  Created by bajo on 2022-07-07.
//

import UIKit

class HomeViewController: UIViewController {

    private var tableview: UITableView!
    private var data: [LibObject]!
    private let user  = UserDefaults.standard.value(forKey: "user")!
    private let header = LargeSliderCollection(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 220))
    private var headerData: LibObject!
    
    private var emptyView = EmptyContentViewController()
    private var errorView = ErrorViewController()
    
    override func loadView() {
        super.loadView()
        
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.Get(url: "home?user=\(user)") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .success:
                print("success",data!)
                
                self.data = data!
                self.headerData = self.data.removeFirst()
                
                if data!.isEmpty {
                    DispatchQueue.main.async {
                        self.addChild(self.emptyView)
                        self.view.addSubview(self.emptyView.view)
                        self.emptyView.label.text = "Looks like theres nothing in here yet"
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.configureTableview()
                    }
                }
               

            case .notfound:
                print("not found")
                
            case .servererr:
                DispatchQueue.main.async {
                    self.addChild(self.errorView)
                    self.view.addSubview(self.errorView.view)
                    self.errorView.label.text = "Oops. Ran into an error. Check your network"
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func configureTableview(){
        
        
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//        tableview.register(LargeSliderCollection.self, forCellReuseIdentifier: LargeSliderCollection.reuseIdentifier)
        tableview.register(ContentNavigatonSection.self, forCellReuseIdentifier: ContentNavigatonSection.reuseIdentifier)
        tableview.register(AlbumFlowSection.self, forCellReuseIdentifier: AlbumFlowSection.reuseIdentifier)
        tableview.register(TrackFlowSection.self, forCellReuseIdentifier: TrackFlowSection.reuseIdentifier)
        tableview.frame = view.frame
        tableview.separatorColor = .clear
        tableview.backgroundColor = .black
        
        tableview.tableHeaderView = header
        header.initCell(data: headerData.items!)
        
        view.addSubview(tableview)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = TableviewSectionHeader()
        header.tagline.text = self.data[section].tagline
        
        return header
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch( indexPath.section){
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: ContentNavigatonSection.reuseIdentifier) as! ContentNavigatonSection
            cell.configureView(data: data[indexPath.section].items!)
            cell.navigationController = self.navigationController
            return cell
            
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: TrackFlowSection.reuseIdentifier) as! TrackFlowSection
            cell.configure(data: data[indexPath.section].items!, navigationController: self.navigationController!)
            return cell
            
        default:
            let cell = tableview.dequeueReusableCell(withIdentifier: AlbumFlowSection.reuseIdentifier) as! AlbumFlowSection
            cell.configure(data: data[indexPath.section].items!, navigationController: self.navigationController!)
            return cell
        }
    }
}

class LargeSliderCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "large slider"
    var collectionview: UICollectionView!
    var data: [LibItem] = []
    var navigationController: UINavigationController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func initCell(data: [LibItem]){
        
        self.data = data
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionview = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true 
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(FeaturedHeader.self, forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            
//            heightAnchor.constraint(equalToConstant: 200),
            
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: FeaturedHeader.reuseIdentifier, for: indexPath) as! FeaturedHeader
        cell.configure(with: data[indexPath.row], rootVc: self.navigationController, indexPath: indexPath.row)
        return cell
    }
    
}

class ContentNavigatonSection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
   
    static let reuseIdentifier: String = "contentNav"
    var collectionView: UICollectionView!
    var sections: [LibItem]!
    var navigationController: UINavigationController!
    
    func configureView(data: [LibItem]){
        
        sections = data
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 200, height: 80)
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout:  layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CatagoryCollectionCell.self, forCellWithReuseIdentifier: CatagoryCollectionCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatagoryCollectionCell.reuseIdentifier , for: indexPath) as! CatagoryCollectionCell
        cell.configure(catagory: sections[indexPath.row])
        cell.navigationController = navigationController
        return cell
        
    }
    
}
class CatagoryCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "catagoryCell"
    private var catagory: String = ""
    var navigationController: UINavigationController!
    private var tapRecognizer: UITapGestureRecognizer!
    
    func configure(catagory: LibItem){
        
        self.catagory = catagory.title!
        
        addSubview(backgroundImage)
        backgroundImage.image = UIImage(named: catagory.imageURL!)
        backgroundImage.isUserInteractionEnabled = true
        
        addSubview(sectionLabel)
        sectionLabel.text = catagory.title

        layer.cornerRadius = 5
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentCatagoryView))
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            
            sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor)
            
        ])
        
    }
    
    let sectionLabel: UILabel = {
       let view = UILabel()
        view.setBoldFont(with: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    @objc func presentCatagoryView(){
        
        var _view: UIViewController!
        
        switch( catagory){
        case "Trending":
            _view = TrendingCollectionViewController()
            
        case "Videos":
            _view = VideoPageViewController()
        
        case "Trending Videos":
            _view = TrendingVideoViewController()
            
        default:
            return
        }
        
        navigationController.pushViewController(_view, animated: true )
        
    }
    
}

//func dynamicCell<T: UICollectionViewCell>(type: T, collectionview: UICollectionView, indexPath: IndexPath){
//    guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: type.reuseableidentifier, for: IndexPath) as! T
//    else{ return nil }
//
//}
