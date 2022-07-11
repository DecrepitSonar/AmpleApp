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
    
    override func loadView() {
        super.loadView()
        
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.Get(url: "home?user=\(user)") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .success:
                print("success",data!)
                self.data = data!
                
                DispatchQueue.main.async {
                    self.configureTableview()
                }

            case .notfound:
                print("not found")
                
            case .servererr:
                print("Internal Server /err")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func configureTableview(){
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self

        tableview.register(LargeSliderCollection.self, forCellReuseIdentifier: LargeSliderCollection.reuseIdentifier)
        tableview.register(ContentNavigatonSection.self, forCellReuseIdentifier: ContentNavigatonSection.reuseIdentifier)
        tableview.register(AlbumFlowSection.self, forCellReuseIdentifier: AlbumFlowSection.reuseIdentifier)
        tableview.frame = view.frame
        tableview.separatorColor = .clear
        
        view.addSubview(tableview)
        
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if( section > 1 ){
            let header = TableviewSectionHeader()
            
            header.tagline.text = self.data[section].tagline
            
            return header
        }
        
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if( section == 0){
            
            let _view  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//            _view.backgroundColor = .red
            return _view
        }
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch( indexPath.section){
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: LargeSliderCollection.reuseIdentifier) as! LargeSliderCollection
            cell.initCell(data: data[indexPath.section].items!)
            cell.navigationController = self.navigationController
            return cell
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: ContentNavigatonSection.reuseIdentifier) as! ContentNavigatonSection
            cell.configureView(data: data[indexPath.section].items!)
            cell.navigationController = self.navigationController
            return cell
        default:
            let cell = tableview.dequeueReusableCell(withIdentifier: AlbumFlowSection.reuseIdentifier) as! AlbumFlowSection
            cell.configure(data: data[indexPath.section].items!, navigationController: self.navigationController!)
            return cell
        }
    }
    
    
}

protocol customCellType {
    func initCell(data: [LibItem]?)
}

class LargeSliderCollection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "large slider"
    var collectionview: UICollectionView!
    var data: [LibItem] = []
    var navigationController: UINavigationController?

    func initCell(data: [LibItem]){
        
        self.data = data
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionview = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true 
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(FeaturedHeader.self, forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
        collectionview.register(FeaturedVideoHeader.self, forCellWithReuseIdentifier: FeaturedVideoHeader.reuseIdentifier)
//        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionview.backgroundColor = .orange
        
        collectionview.showsHorizontalScrollIndicator = false
        
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 200),
//            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print( scrollView.contentOffset)
        
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
        layout.itemSize = CGSize(width: 200, height: 100)
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout:  layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CatagoryCollectionCell.self, forCellWithReuseIdentifier: CatagoryCollectionCell.reuseIdentifier)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 120),
//            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
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
    var catagory: String = ""
    var navigationController: UINavigationController!
    
    var tapRecognizer: UITapGestureRecognizer!
    
    func configure(catagory: LibItem){
        
        self.catagory = catagory.title!
        
        addSubview(backgroundImage)
        backgroundImage.image = UIImage(named: catagory.imageURL!)
        backgroundImage.isUserInteractionEnabled = true
        addSubview(sectionLabel)
        sectionLabel.text = catagory.title
        backgroundColor = .orange
        layer.cornerRadius = 5
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentCatagoryView))
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

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
        switch( catagory){
        case "Trending":
            let _view = TrendingCollectionViewController()
            navigationController.pushViewController(_view, animated: true )
            
        case "Videos":
            let _view = VideoPageViewController()
            navigationController.pushViewController(_view, animated: true )
            
        default:
            return
        }
    }
    
}

//func dynamicCell<T: UICollectionViewCell>(type: T, collectionview: UICollectionView, indexPath: IndexPath){
//    guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: type.reuseableidentifier, for: IndexPath) as! T
//    else{ return nil }
//
//}
