////
////  HeaderTableViewCell.swift
////  spotlight
////
////  Created by Robert Aubow on 6/29/21.
////
//
//import UIKit
//
//class HeaderTableViewCell: UITableViewCell {
//
//    static let identifier = "FeaturHeader"
//    
//    let container: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 375))
//        view.backgroundColor = .red
//        return view
//    }()
//    
//    let headerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "In the spotlight"
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Helvetica Neue", size: 20)
//        label.font = UIFont.boldSystemFont(ofSize: 25)
//        
//        return label
//    }()
//    let headerStackContainer: UIStackView = {
//        let view = UIStackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
////        view.layer.borderWidth = 1
//        view.distribution = .fillEqually
//        view.alignment = .leading
//        view.axis = .horizontal
//        view.spacing = 20
//        return view
//    }()
//    
//    let headerScrollContainer: UIScrollView = {
//        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        view.showsHorizontalScrollIndicator = false
//        return view
//    }()
//    
//    public func configureHeader( with albums: [Album]){
//    
//        contentView.addSubview(container)
//        container.addSubview(headerLabel)
//        headerLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
//        headerLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
//        
//        container.addSubview(headerScrollContainer)
//        headerScrollContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
//        headerScrollContainer.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
//        headerScrollContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
//        headerScrollContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        
//        headerScrollContainer.addSubview(headerStackContainer)
//        headerStackContainer.leadingAnchor.constraint(equalTo: headerScrollContainer.leadingAnchor, constant: 20).isActive = true
//
//        headerStackContainer.heightAnchor.constraint(equalToConstant: 280).isActive = true
//        headerStackContainer.widthAnchor.constraint(equalToConstant: 1200).isActive = true
//        
////        let images = ["6lack", "phoney", "mac","frank"]
//        
//        for i in 0..<albums.count {
//            let image = LargeAlbumCover(frame: CGRect(x: 0 , y: 0, width: 250, height: 200))
//            let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTrackDetail))
//            image.isUserInteractionEnabled = true
//            image.addGestureRecognizer(imageGestureRecognizer)
//
//            image.SetupAlbumCover(album: albums[i])
//            headerStackContainer.addArrangedSubview(image)
//        }
//    }
//    
//    @objc private func showTrackDetail(){
//        print("Featured Track")
//        
////        let trackDetail = TrackOverviewController()
////        trackDetail.modalTransitionStyle = .crossDissolve
////        trackDetail.modalPresentationStyle = .fullScreen
////        window?.rootViewController?.present(trackDetail, animated: true)
//    }
//    
//    override func layoutSubviews() {
//        headerScrollContainer.contentSize = CGSize(width: 1250, height: 0)
//    }
//    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//
//}
