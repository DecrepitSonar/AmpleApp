//
//  TrackHistoryScrollTableViewCell.swift
//  spotlight
//
//  Created by Robert Aubow on 6/29/21.
//

import UIKit

class TrackHistoryScrollTableViewCell: UITableViewCell {

    static let identifier = "TrackHistory"
    
    let container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
//        view.backgroundColor = .red
        return view
    }()
    
    let recentTracksLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Tracks"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    let moreTracks: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let moreRecentTracksBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let recentTracksContainer: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    let trackStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1500).isActive = true
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        view.backgroundColor = .green
        view.spacing = 20
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.axis = .horizontal
        return view
    }()
    
    func configure(){
        contentView.addSubview(container)
        
        container.addSubview(recentTracksLabel)
        recentTracksLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        recentTracksLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true

        container.addSubview(moreRecentTracksBtn)
        moreRecentTracksBtn.leadingAnchor.constraint(equalTo: recentTracksLabel.trailingAnchor, constant: 20).isActive = true

        moreRecentTracksBtn.bottomAnchor.constraint(equalTo: recentTracksLabel.bottomAnchor).isActive = true
        moreRecentTracksBtn.addTarget(self, action: #selector(presentTrackHistory), for: .touchUpInside)

        container.addSubview(recentTracksContainer)
        recentTracksContainer.topAnchor.constraint(equalTo: recentTracksLabel.bottomAnchor, constant: 20).isActive = true

        recentTracksContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        recentTracksContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true

        recentTracksContainer.addSubview(trackStack)
        trackStack.leadingAnchor.constraint(equalTo: recentTracksContainer.leadingAnchor, constant: 20).isActive = true
        
        
        
        // albums

        let track = MediumTrackComponent()
        track.setupAlbum(image: UIImage(named: "channelOrange")!, artist: "Frank Ocean", name: "Siera Leone")
//        trackStack.addArrangedSubview(album)

        let track1 = MediumTrackComponent()
        track1.setupAlbum(image: UIImage(named: "bandana")!, artist: "Freddie Gibbs", name: "Bandanna")
//        trackStack.addArrangedSubview(album)

        let track2 = MediumTrackComponent()
        track2.setupAlbum(image: UIImage(named: "brent")!, artist: "Brent Fayaz", name: "Stay Down")
//        trackStack.addArrangedSubview(album)

        let track3 = MediumTrackComponent()
        track3.setupAlbum(image: UIImage(named: "beloved")!, artist: "Dave East", name: "It's Lit (ft Style P")
//        trackStack.addArrangedSubview(album)

        let track4 = MediumTrackComponent()
        track4.setupAlbum(image: UIImage(named: "driveslow")!, artist: "Mac Ayres", name: "Drive Slow")
//        trackStack.addArrangedSubview(album)

        let track5 = MediumTrackComponent()
        track5.setupAlbum(image: UIImage(named: "Dinner-Party")!, artist: "Terrance Martin", name: "Freeze Tage ( ft. Phoelix")
//        trackStack.addArrangedSubview(album)

        let track6 = MediumTrackComponent()
        track6.setupAlbum(image: UIImage(named: "backofmymind")!, artist: "H.E.R.", name: "Back of My Mind")

        let tracks = [track, track1, track2, track3, track4, track5, track6]
        let TrackGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTrackDetail))
        TrackGestureRecognizer.numberOfTapsRequired = 1
        
        for i in 0..<tracks.count {
            trackStack.addArrangedSubview(tracks[i])
            tracks[i].isUserInteractionEnabled = true
            tracks[i].addGestureRecognizer(TrackGestureRecognizer)
        }
    }
    override func layoutSubviews() {
        recentTracksContainer.contentSize = CGSize(width: 870, height: 0)
    }
    
    @objc private func showTrackDetail(sender: UIGestureRecognizer){
        print("Track Detail")
        
    }
    
    @objc private func presentTrackHistory(){
        print("Track history")
        
//        let trackHistory = TrackHistoryViewController()
//        trackHistory.modalTransitionStyle = .crossDissolve
//        trackHistory.modalPresentationStyle = .fullScreen
//        window?.rootViewController?.present(trackHistory, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
