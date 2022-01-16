//
//  ProfileViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import UIKit

class Library: UIViewController, UISearchResultsUpdating {
    
    var tableView: UITableView!
    
    let header = HeaderNavView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(loadSettings))
        navigationItem.rightBarButtonItem = button
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Library"
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.frame
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        view.backgroundColor = .red
        view.addSubview(tableView)
        
        view.addSubview(header)

//        navigation.backgroundColor = .systemRed

//        navigation.addSubview(saved)
//        navigation.addSubview(History)
//        navigation.addSubview(Artists)

//        view.addSubview(scrollContainer)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let vc = searchController.searchResultsController as? SearchResultViewController
        vc?.view.backgroundColor = .systemRed
        print(text)
    }
    
    let navigation: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
//        view.backgroundColor = .red
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saved: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("Saved", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let History: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("History", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
  
    let Artists: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("Artists", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let scrollContainer: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .red
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    func createButton(title: String) -> UIButton{
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle(title, for: .normal)
        return btn
    }
    
    @objc func loadSettings(){
        let view =  SettingsViewController()
        
        navigationController?.pushViewController(view, animated: true)
    }

}

class HeaderNavView: UIView {
    
    let labels: [String] = ["Saved","History","Artists"]
    var scrollview: UIScrollView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        scrollview.backgroundColor = .red
    
        addSubview(scrollview)
        
        for i in 1..<labels.count {
            
            let label = UILabel()
            label.text = labels[i]
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
            
            scrollview.addSubview(label)
//            label.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor, constant: 20).isActive = true
            
        }
        
        
    }
}

extension Library: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        return cell
    }
    
}


