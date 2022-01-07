//
//  SearchResultViewController.swift
//  spotlight
//
//  Created by bajo on 2021-12-11.
//

import UIKit

class SearchResultViewController: UIViewController {

    var tableview: UITableView!
    
    var data: [LibItem]?{
        didSet{
            tableview.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        tableview = UITableView()
        
        // Do any additional setup after loading the view.
    }
    
}

//extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (data!.count > 0){
//            return data!.count
//        }else{
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

