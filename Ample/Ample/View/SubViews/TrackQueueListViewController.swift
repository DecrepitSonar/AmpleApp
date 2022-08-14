//
//  TrackQueueListViewController.swift
//  spotlight
//
//  Created by bajo on 2021-11-13.
//

import UIKit
import CoreAudio

class TrackQueueListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var effect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    var queue = AudioManager.shared.audioQueue
    
    var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = audioQueue
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTable),
                                               name: Notification.Name("update"),
                                               object: nil)

        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        tableview.separatorColor = UIColor.clear
        view.addSubview(effect)
        
        view.addSubview(tableview)
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        effect.frame = view.frame
        tableview.frame = view.frame
    }
    
    @objc func reloadTable(){
        DispatchQueue.main.async{
            self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        
        case 0:
            return AudioManager.shared.audioQueue.count
            
        default:
            return AudioManager.shared.previousTracks.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Up Next"
            
        default:
            return "Previous"
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch( indexPath.section ){
        case 0:
            AudioManager.shared.previousTracks.insert(AudioManager.shared.currentQueue!, at: 0)
            AudioManager.shared.initPlayer(track: AudioManager.shared.audioQueue[indexPath.row], tracks: nil)
        default:
            AudioManager.shared.previousTracks.insert(AudioManager.shared.currentQueue!, at: 0)
            AudioManager.shared.initPlayer(track: AudioManager.shared.previousTracks[indexPath.row], tracks: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section{
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStrip
            cell!.configure(track: AudioManager.shared.audioQueue[indexPath.row])
            return cell!
            
        default:
            
            guard AudioManager.shared.previousTracks.isEmpty else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStrip
                cell!.configure(track: AudioManager.shared.previousTracks[indexPath.row])
                cell!.layer.opacity = 0.1
                return cell!
                
            }
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
    }
    
}
