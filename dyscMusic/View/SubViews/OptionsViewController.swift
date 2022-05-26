//
//  OptionsViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-24.
//

import UIKit


class OptionsViewController: UIViewController {

    var tableview: UITableView!
    let options = ["Save", "Add to Queue", "Share", "Add to playlist"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        config()
    }
    
    func config(){
        
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.frame = view.frame
        view.addSubview(tableview)
        
    }

}

extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel!.text = options[indexPath.row]
        return cell
    }
    
    
}
