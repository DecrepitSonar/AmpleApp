//
//  OptionsViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-24.
//

import UIKit

class OptionsHeader: UIView {
    
    let headerImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.heightAnchor.constraint(equalToConstant: 175).isActive = true
        image.widthAnchor.constraint(equalToConstant: 175).isActive = true
        return image
    }()
    
    let trackTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [headerImage, trackTitle, nameLabel])
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -25)
        ])
    }
    
    func config(object: Track){
        headerImage.setUpImage(url: object.imageURL, interactable: false)
        trackTitle.text = object.title
        nameLabel.text = object.name
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
}

enum ObjectType {
    case Album
    case Track
}
class OptionsViewController: UIViewController {

    var type: ObjectType?
    var track: Track?
    var Album: Album?
    var nvc: UINavigationController!
    
    var effect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    var tableview: UITableView!
    var buttons =  [UIButton]() {
        didSet{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [saveButton, shareButton, addToQueueButton, addToPlayListButton, moreInfoBtn ]
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.3)
        
        config()
    }
    
    func config( ){
        
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(OptionsListCell.self, forCellReuseIdentifier: OptionsListCell.reuseIdentifier)
        tableview.frame = view.frame
        tableview.separatorColor = .clear
        tableview.backgroundColor = .clear
        view.addSubview(effect)
        view.addSubview(tableview)
        
        let TrackHeader = OptionsHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:300 ))
        tableview.tableHeaderView = TrackHeader
        
        switch( type ){
        case .Album:
            TrackHeader.headerImage.setUpImage(url: Album!.imageURL, interactable: false)
            TrackHeader.nameLabel.text = Album!.name
            TrackHeader.trackTitle.text = Album!.title
            
        case .Track:
            TrackHeader.headerImage.setUpImage(url: track!.imageURL, interactable: false)
            TrackHeader.nameLabel.text = track!.name
            TrackHeader.trackTitle.text = track?.title
        case .none:
            return
        }
        
    }

    override func viewDidLayoutSubviews() {
        effect.frame = view.frame
    }
    
    let shareButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20)), for: .normal)
        btn.tag = 4
        return btn
    }()
    let addToQueueButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20)), for: .normal)
        btn.tag = 2
        return btn
    }()
    let addToPlayListButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "list.triangle", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20)), for: .normal)
        btn.tag = 3
        return btn
    }()
    let saveButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20)), for: .normal)
        btn.tag = 1
        return btn
    }()
    let moreInfoBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 20)), for: .normal)
        btn.tag = 5
        return btn
    }()
}

extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let trackDetail = TrackViewController()
        trackDetail.trackId = track!.id
        nvc.presentingViewController?.navigationController?.pushViewController(trackDetail, animated: true)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: OptionsListCell.reuseIdentifier) as! OptionsListCell
        cell.config(listItem: buttons[indexPath.row])
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
}

class OptionsListCell: UITableViewCell {
    
    static let reuseIdentifier: String = "listCell"
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 15)
        return label
    }()
    func config(listItem: UIButton){
        
        let stack = UIStackView(arrangedSubviews: [listItem, label])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        
        listItem.tintColor = .label
        switch( listItem.tag){
        case 1:
            label.text = "Save"
        case 2:
            label.text = "Add to Queue"
        case 3:
            label.text = "Add to Playlists"
        case 4:
            label.text = "Share"
        case 5:
            label.text = "See More"
        default: return
        }
        
        addSubview(stack)
        NSLayoutConstraint.activate([
        
            listItem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            listItem.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
