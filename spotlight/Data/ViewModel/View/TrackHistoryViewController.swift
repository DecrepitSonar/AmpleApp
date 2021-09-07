//
//  TrackHistoryViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/27/21.
//

import UIKit

class HeaderLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(label: String){
        self.text = label
    }
}
class TrackHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tracks = [Song]() {
        didSet{
            tableview.reloadData()
        }
    }
    
    var tableview  = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.barTintColor = .white
        title = "Recently played"
        
        
        tableview.delegate = self
        tableview.dataSource = self

        view.addSubview(tableview)

        tableview.register(TrackStripCell.self, forCellReuseIdentifier: "trackcell")
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        tableview.tableHeaderView = sectionHeader
        // Do any additional setup after loading the view.
        getTrackHistory()
    }

    override func viewDidLayoutSubviews() {
        tableview.frame = view.bounds
    }
    
    func getTrackHistory(){
        NetworkManager.getTrackHistory { (result) in
            switch(result){
            case .success(let tracks):
                self.tracks = tracks
            case .failure(let err):
                print(err)
            }
        }
    }
    
    let sectionHeader: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .red
        return view
    }()
}



//TrackTablvi
extension TrackHistoryViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = tracks[indexPath.row].artist

        let cell = tableview.dequeueReusableCell(withIdentifier: "trackcell", for: indexPath) as! TrackStripCell
        cell.configure(with: tracks[indexPath.row].Artists ?? "", trackname: tracks[indexPath.row].Title ?? "", img: tracks[indexPath.row].Image ?? "")

        return cell
    }
}
