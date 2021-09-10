////
////  GenreCell.swift
////  spotlight
////
////  Created by Robert Aubow on 6/29/21.
////
//
//import UIKit
//
//class GenreCell: UITableViewCell {
//    static let identifier = "genreCell"
//
//    
//    let container: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
////        view.backgroundColor = .blue
//        
//        return view
//    }()
//    
//    let genreLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.text = "Genres"
//        label.font = UIFont(name: "Helvetica Neue", size: 20)
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//    
//        return label
//    }()
//    let moreGenreBtn: UIButton = {
//        let btn = UIButton()
//        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
//        btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        return btn
//    }()
//    let genreScrollContainer: UIScrollView = {
//        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive  = true
//        view.showsHorizontalScrollIndicator = false
//        return view
//    }()
//    let genreStack: UIStackView = {
//        let view = UIStackView()
//        view.distribution = .fillEqually
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.axis = .horizontal
//        view.alignment = .fill
//        view.spacing = 20
//        return view
//    }()
//    
//    func configure(){
//        configureCell()
//    }
//    
//    private func configureCell(){
//        contentView.addSubview(container)
//        container.addSubview(genreLabel)
//
//        genreLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
//        genreLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
//
//        container.addSubview(moreGenreBtn)
//        moreGenreBtn.bottomAnchor.constraint(equalTo: genreLabel.bottomAnchor).isActive = true
//        moreGenreBtn.leadingAnchor.constraint(equalTo: genreLabel.trailingAnchor, constant: 20).isActive = true
//
//        container.addSubview(genreScrollContainer)
//        genreScrollContainer.topAnchor.constraint(equalTo: genreLabel.bottomAnchor,constant : 20).isActive = true
//
//        genreScrollContainer.addSubview(genreStack)
//
//        genreStack.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        genreStack.widthAnchor.constraint(equalToConstant: 2000).isActive = true
//        genreStack.leadingAnchor.constraint(equalTo: genreScrollContainer.leadingAnchor, constant: 20).isActive = true
//
//        let rnbGenre = Genres(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        rnbGenre.setupImage(image: UIImage(named: "rnb")!)
//
//        let rapGenre = Genres(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        rapGenre.setupImage(image: UIImage(named: "rap-life")!)
//
//        let popGenre = Genres(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        popGenre.setupImage(image: UIImage(named: "pop")!)
//
//        let soulGenre = Genres(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        soulGenre.setupImage(image: UIImage(named: "soul")!)
//
//        let afroBeats = Genres(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        afroBeats.setupImage(image: UIImage(named: "afro")!)
//        
//        let genres = [rnbGenre, rapGenre, popGenre,soulGenre, afroBeats]
//
//        for i in 0..<genres.count{
//            genreStack.addArrangedSubview(genres[i])
//        }
//        
////        genreStack.addArrangedSubview(rapGenre)
//    }
//    
//    override func layoutSubviews() {
//        genreScrollContainer.contentSize = CGSize(width: 2050, height: 0)
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
