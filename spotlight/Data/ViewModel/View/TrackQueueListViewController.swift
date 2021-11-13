//
//  TrackQueueListViewController.swift
//  spotlight
//
//  Created by bajo on 2021-11-13.
//

import UIKit

class TrackQueueListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var queue: [String]?
    
    var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableview)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        tableview.frame = view.frame
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(queue!.isEmpty || queue == nil){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Nothing in queue"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = queue![indexPath.row]
        
        return cell
    }
    
}
