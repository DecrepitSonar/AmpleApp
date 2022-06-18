//
//  MainViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-04-22.
//

import UIKit

class MainViewController: UIViewController, UISearchResultsUpdating {

    
    let viewOne = MusicViewController()
    let viewTwo = VideoLibraryViewController()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = false
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let navigationContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 125, width: UIScreen.main.bounds.width, height: 50))
//        view.backgroundColor = .red
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5).cgColor
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let button1: UIButton = {
        let btn = UIButton()
        btn.setTitle("Music", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(transitionToSelectedViewController(sender:)), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    let button2: UIButton = {
        let btn = UIButton()
        btn.setTitle("Video", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(transitionToSelectedViewController(sender:)), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc func transitionToSelectedViewController(sender: UIButton){
        print(sender.tag)
        switch sender.tag {
        case 1:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            scrollView.scrollsToTop = true
            viewOne.didMove(toParent: self)
        case 2:
            scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
            scrollView.scrollsToTop = true
            viewTwo.didMove(toParent: self)
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        title = "Browse"
        let stack = UIStackView(arrangedSubviews: [button1, button2,])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
//
        scrollView.bounds = view.bounds
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(navigationContainer)
        navigationContainer.addSubview(stack)
        view.addSubview(scrollView)
        scrollView.addSubview(containerOne)
//
        addChild(viewOne)
        containerOne.addSubview(viewOne.view)
//
        scrollView.addSubview(containerTwo)
        addChild(viewTwo)
        containerTwo.addSubview(viewTwo.view)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: navigationContainer.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: navigationContainer.topAnchor),
            stack.leadingAnchor.constraint(equalTo: navigationContainer.leadingAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: navigationContainer.bottomAnchor),
//            stack.trailingAnchor.constraint(equalTo: navigationContainer.trailingAnchor)
        ])
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text else {
            return
        }

        let vc = searchController.searchResultsController as? SearchResultViewController

        if (text.isEmpty){
            return
        }

        NetworkManager.getSearchResult(query: text){ result in
            switch(result) {
            case .success(let data):
                DispatchQueue.main.async {
                    vc?.searchQuery = text
                    vc?.data = data
                }

            case .failure(let err):
                vc?.data = []
            }

        }

        print(text)
    }
    
    override func viewWillLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height)
    }
    
    
    let containerOne: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        return v
    }()
    
    let containerTwo: UIView = {
        let view = UIView(frame: CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        return view
    }()
}
