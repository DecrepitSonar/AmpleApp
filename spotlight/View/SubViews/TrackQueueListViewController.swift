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

    var queue: [Track]?
    
    var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = AudioManager.audioQueue
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.1)

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return AudioManager.audioQueue.count
        
        case 2:
            return AudioManager.previousTracks.count
            
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Up Next"
        case 2:
            return "Previous"
            
        default:
            return "Now playing"
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(queue!.isEmpty || queue == nil){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.textLabel?.text = "Nothing in queue"
//            
//            return cell
//        }
        switch indexPath.section{
            
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStrip
            cell!.configure(track: queue![indexPath.row])
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStrip
            cell!.configure(track: AudioManager.previousTracks[indexPath.row])
            cell!.layer.opacity = 0.1
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStrip
            cell!.configure(track: AudioManager.getCurrentTrack())
            return cell!
        }
    }
    
}
