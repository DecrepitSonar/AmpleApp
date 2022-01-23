//
//  DetailViewController.swift
//  spotlight
//
//  Created by bajo on 2022-01-23.
//

import UIKit

class DetailViewController: UIViewController {

    var albumId = String()
    var data: LibObject?
    var tableview: UITableView!
    
    var loadingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .red
        
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(loadingView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getAlbum(id: albumId) { Result in
            switch Result {
            case .success(let data ):
                self.data = data
                
                print(self.data)
                
                self.loadingView.removeFromSuperview()
                
                self.loadTableview()

            case .failure(_):
                print()
            }
        }
    }
    
    
    func loadTableview(){
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
//        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableview.frame = view.frame
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.separatorColor = UIColor.clear
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        tableview.contentInsetAdjustmentBehavior = .never

        setupHeader()
        
        view.addSubview(tableview)
        
    }
    func setupHeader(){
       
        let header = DetailHeaders(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 630))
        header.artist.text = data?.name
        header.albumImage.setUpImage(url: data!.imageURL!)
        header.imageContainer.setUpImage(url: data!.imageURL!)
        header.trackTitle.text = data?.title
        header.artistAviImage.setUpImage(url: data!.artistImgURL!)
        header.vc = navigationController
        
        header.artistId = data!.artistId!
        self.tableview.tableHeaderView = header
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.items!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tracks"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let date = Date()
        let publishDate = date.formateDate(dateString: data!.releaseDate!)
        
        
        return "Published \(publishDate)"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as! TrackCell
        let item = data!.items![indexPath.row] as! LibItem
        cell.configure(with: item)
        cell.backgroundColor = .clear
        return cell
    }
    
    
}
