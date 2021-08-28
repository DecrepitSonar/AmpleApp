//
//  TableViewCell.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import UIKit

class TrackStripCell: UITableViewCell {

    static let identifier = "trackcell"
    
    let track = TrackStrip()
    
    func configure(with artist: String, trackname: String, img: String){
        contentView.addSubview(track)
        track.configure(artist: artist, trackName: trackname, albumImg: img)
    }
}
