//
//  SearchResultViewController.swift
//  spotlight
//
//  Created by bajo on 2021-12-11.
//

import UIKit

class SearchResultViewController: UIViewController {

    var tableview: UITableView!
    var searchQuery = ""
    
    var data = [LibItem](){
        didSet{
            tableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.frame = view.frame
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.separatorColor = UIColor.clear
        
        view.addSubview(tableview)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        tableview.register(AviTableCell.self, forCellReuseIdentifier: AviTableCell.reuseIdentifier)
        
    }
    
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(data.count > 0){
            return data.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results for \"\(searchQuery)\""
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(data.count > 0){
            switch(data[indexPath.row].type){
            case "Artist":
                return configureTableCell(tableview: tableView, AviTableCell.self, with: data[indexPath.row], indexPath: indexPath)
                
            default:
                return configureTableCell(tableview: tableView, TrackStrip.self, with: data[indexPath.row], indexPath: indexPath)
            }
        }
        else{
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel!.text = "No results found for \"\(searchQuery)\""
            return cell
        }
        
    }
    
}

func configureTableCell<T: TableCell>( tableview: UITableView, _ cellType: T.Type, with item: LibItem, indexPath: IndexPath) -> T{

    guard let cell = tableview.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
        fatalError("")
    }
    switch(item.type){
        
    case "Artist":
        cell.configureWithSet(image: item.imageURL, name: "", artist: item.name!, type: item.type!)

    default:
        cell.configureWithSet(image: item.imageURL, name: item.title!, artist: item.name!, type: item.type!)
    }
    
    return cell

}
