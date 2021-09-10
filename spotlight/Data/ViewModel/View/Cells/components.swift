//
//  components.swift
//  spotlight
//
//  Created by Robert Aubow on 6/18/21.
//

import Foundation
import UIKit

// Featured Components
protocol ViewManager {
    func setRootVc(vc: UINavigationController)
    func presentTrackOverview( AlbumId: String?, TrackId: String?, Artist: Artist?)
}
protocol ButtonViewManager {
    func presentViewPage()
}

class ImageGestureRecognizer: UITapGestureRecognizer{
    var albumId: String?
    var trackId: String?
    var artist: Artist?
}
class ButtonGestureRecognizer: UITapGestureRecognizer{
    var vc: UIViewController?
}

class FeaturedAlbums: UIScrollView, ViewManager{
    
    var vc: UINavigationController?
    var tapGesture = ImageGestureRecognizer()
    
    func presentTrackOverview( AlbumId: String?, TrackId: String?, Artist: Artist?){
//        let view = TrackOverviewController()
    
//        view.title = "6lack"
//        view.getAlbumDetail(albumId: AlbumId!)
//        view.getTracks(albumId: AlbumId!)
//
        print("presenting...")
//        vc!.pushViewController(view, animated: true)
    }
    func setRootVc(vc: UINavigationController){
        self.vc = vc
    }
    @objc func showTrackDetail(_ sender: ImageGestureRecognizer){
        presentTrackOverview(AlbumId: sender.albumId, TrackId: nil, Artist: nil)
    }
    
    var albums = [Album]() {
        didSet{
            configure()
        }
    }
    
    var StackView = UIStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        showsHorizontalScrollIndicator = false
        
        
        NetworkManager.GetAlbumsFeatured{ (result) in
            switch(result){
            case .success(let abs):
                self.albums = abs
            case .failure(let err):
                print(err)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("There was an error")
    }
    
    func configure(){
    
        contentSize = CGSize(width: 1320, height: 0)
        StackView = UIStackView(frame: CGRect(x: 20, y: 0, width: 1300, height: 300))
        self.addSubview(StackView)
        StackView.axis = .horizontal
        StackView.distribution = .fillEqually
        StackView.spacing = 20
        
        for i in 0..<albums.count{
            
            tapGesture = ImageGestureRecognizer(target: self, action: #selector(showTrackDetail(_:)))
            
            tapGesture.albumId = albums[i].Id
            
            let img = UIImageView()
            img.image = UIImage(named: albums[i].Image)
            img.clipsToBounds = true
            img.layer.cornerRadius = 10
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(tapGesture)
            
            StackView.addArrangedSubview(img)
        }
    }
    
    
} // Featured Albums
//class FeaturedArtists: UIScrollView, ViewManager{
//    
//    var artists = [Artist](){
//        didSet{
//            configure()
//        }
//    }
//    
//    var Stackview = UIStackView()
//    var imgRecognizer = ImageGestureRecognizer()
//    var navigation: UINavigationController?
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        
//        contentSize = CGSize(width: 1200, height: 0)
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: 120).isActive = true
//        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
//        showsHorizontalScrollIndicator = false
//        
//        NetworkManager.getArtistsFeatured { (result) in
//            switch(result){
//            case .success(let artists):
//                self.artists = artists
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("")
//    }
//    
//    func configure(){
//        
//        Stackview = UIStackView(frame: CGRect(x: 20, y: 0, width: 700, height: 120))
//        
//        self.addSubview(Stackview)
//        Stackview.axis = .horizontal
//        Stackview.spacing = 20
//        Stackview.distribution = .fillEqually
//        
//        for i in 0..<artists.count{
//            
//            imgRecognizer = ImageGestureRecognizer(target: self, action: #selector(artistTap(_sender:)))
//            imgRecognizer.artist = artists[i]
//            
//            let artist = AViCard()
//            artist.addGestureRecognizer(imgRecognizer)
//            artist.configureCard(artist: artists[i])
//            Stackview.addArrangedSubview(artist)
//        }
//    }
//    func setRootVc(vc: UINavigationController){
//        navigation = vc
//    }
//    
//    @objc func artistTap(_sender: ImageGestureRecognizer){
//        presentTrackOverview(AlbumId: nil, TrackId: nil, Artist: _sender.artist)
//        
//    }
//    
//    func presentTrackOverview( AlbumId: String?, TrackId: String?, Artist: Artist?) {
//        print(Artist!)
//        
//        let profile = ProfileViewController()
//        navigation!.pushViewController(profile, animated: true)
//    }
//
//    
//    
//    
//} // Featured Artists
class MediumSlider: UIScrollView {
    let Stackview = UIStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        showsHorizontalScrollIndicator = false
        
        // setup stackview
        Stackview.axis = .horizontal
        Stackview.distribution = .fillEqually
        Stackview.spacing = 20
    
        self.addSubview(Stackview)
        
        // stack constraints
        Stackview.translatesAutoresizingMaskIntoConstraints = false
        Stackview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
} // concrete slider class
class TrackHistory: MediumSlider {
    
    var tracks = [Song]() {
        didSet{
            configure()
        }
    }
    
    var vc = UINavigationController()
    var tapGesture = ImageGestureRecognizer()
    
    override init(frame: CGRect){
        super.init(frame: frame)
    
//        layer.borderWidth = 1
//        layer.borderColor = UIC/olor.red.cgColor
        heightAnchor.constraint(equalToConstant: 200).isActive = true
//        contentSize = CGSize(width: 2000, height: 0)
        
        NetworkManager.getTrackHistory { (result) in
            switch(result){
            case .success(let songs):
                self.tracks = songs
//                print("Song", songs)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError(" no storyboard")
    }
    
    func setRootView(view: UINavigationController){
        vc = view
    }
    func configure(){
        
        contentSize = CGSize(width: tracks.count * (150 + 22), height: 0)
        for i in 0..<tracks.count{
            
            tapGesture = ImageGestureRecognizer(target: self, action: #selector(showTrackHistory(_:)))
            tapGesture.trackId = tracks[i].Id
            tapGesture.albumId = tracks[i].AlbumId
            
            let card = SmallTrackCard()
            card.configure(track: tracks[i])
            card.isUserInteractionEnabled = true
            card.addGestureRecognizer(tapGesture)
            Stackview.addArrangedSubview(card)
        }
    }
    
    @objc func showTrackHistory(_ sender: ImageGestureRecognizer){
        presentTrackOverview(AlbumId: sender.albumId, TrackId: sender.trackId)
    }
    
    func presentTrackOverview(AlbumId: String?, TrackId: String?) {
//        let view = TrackOverviewController()
        
//        view.getSingleTrack(trackId: TrackId!)
//        view.getAlbumDetail(albumId: AlbumId!)

//        vc.pushViewController(view, animated: true)
    }
    
} // User player history
class Card: UIView{
    let img = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        
        self.addSubview(self.img)
        
        // image constraints
        img.translatesAutoresizingMaskIntoConstraints = false
        img.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        img.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        img.heightAnchor.constraint(equalToConstant: 150).isActive = true
        img.widthAnchor.constraint(equalToConstant: 150).isActive = true
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
} // concrete card class
class SmallTrackCard: Card{

    let artistLabel = UILabel()
    let trackLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        // setup container
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(track: Song){
        
        // setup image
        self.img.image = UIImage(named: track.Image)
        
        // setup artist label
        artistLabel.text = track.Artists
        artistLabel.textColor = .white
        artistLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.addSubview(artistLabel)
        
        // artist label constraints
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
//        artistLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10).isActive = true
        
        // setup track name label
        trackLabel.text = track.Title
        trackLabel.textColor = .white
        
        
        self.addSubview(trackLabel)
        
        // track name constraints
        trackLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor).isActive = true
        trackLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
} // Small Track card
class AlbumCard: Card{
    
    let artistLabel = UILabel()
    let albumLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(album: Album){
        
        // setup image
        self.img.image = UIImage(named: album.Image)
        self.img.contentMode = .scaleAspectFill
        
        self.addSubview(self.img)
        
        // image constraints
        img.translatesAutoresizingMaskIntoConstraints = false
        img.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        img.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        img.heightAnchor.constraint(equalToConstant: 150).isActive = true
        img.widthAnchor.constraint(equalToConstant: 150).isActive = true
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // setup artist label
        artistLabel.text = album.Artist
        artistLabel.textColor = .white
        artistLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.addSubview(artistLabel)
        
        // artist label constraints
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
//        artistLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10).isActive = true
        
        // setup album name label
        albumLabel.text = album.Name
        albumLabel.textColor = .white
        
        
        self.addSubview(albumLabel)
        
        // album name constraints
        albumLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor).isActive = true
        albumLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
} // Album card with image and label
class AlbumSlider: MediumSlider {
    var albums = [Album]() {
        didSet{
            configure()
        }
    }
    
//    let Stackview = UIStackView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        NetworkManager.getAlbums { (result) in
            switch(result){
            case .success(let albums):
                self.albums  = albums
            case .failure(let err):
                print(err)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(){
    
        contentSize = CGSize(width: albums.count * (150 + 22), height: 0)

        for i in 0..<albums.count{
            let album = AlbumCard()
            album.configure(album: albums[i])
            
            Stackview.addArrangedSubview(album)
        }
        
        
        
    }
} // Slider for albums
class PlaylistCard: Card{
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(playlist: Playlist){
        img.image = UIImage(named: playlist.Image)
    }
} // playlist image
class PlaylistSlider: MediumSlider{
    
    var playlists = [Playlist]() {
        didSet{
            configure()
        }
    }
    
    let img = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        NetworkManager.getPlaylists { (result) in
            switch(result){
            case .success(let playlists):
                self.playlists = playlists
            case .failure(let err):
                print(err)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(){
        contentSize = CGSize(width: playlists.count * (150 + 22), height: 0 )
        
        for i in 0..<playlists.count{
            let card = PlaylistCard()
            card.configure(playlist: playlists[i])
            
            Stackview.addArrangedSubview(card)
        }
    }
    
} // Slider for playlists
class Label: UIView, ButtonViewManager{
    
    var vc: UINavigationController?
    var tapGesture = ButtonGestureRecognizer()
    var view: UIViewController?
    let label = UILabel()
    let btn = UIButton()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("no storyboard")
    }
    
    func configure(text: String, withNavButton: Bool?, view: UINavigationController?){
        vc = view
        
        label.text = text
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.addSubview(label)
        
        // label constraints
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        tapGesture = ButtonGestureRecognizer(target: self, action: #selector(showpage))
    
        if (withNavButton == true) {
            // button config
            btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.5)
            btn.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
            
            self.addSubview(btn)

            // button constraints
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            btn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            btn.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func showpage(){
        presentViewPage()
    }
    
    func presentViewPage() {
        let Vc = TrackHistoryViewController()
        vc!.pushViewController(Vc, animated: true)
    }
} // Section Label with button
class AViCard: UIView {
    
    let imgView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
//        layer.borderColor = UIColor.red.cgColor
//        layer.borderWidth = 1
//
    }
    
    required init?(coder: NSCoder){
        fatalError("")
    }
    
    func configureCard(img: String, name: String){
        setupImg(img: img)
        setupLabel(name: name)
    }
    func setupImg(img: String){
        imgView.image = UIImage(named: img)
        imgView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imgView.layer.cornerRadius = 35
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        // add image to view
        self.addSubview(imgView)
        
        // configure constraints
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
    }
    func setupLabel(name: String){
        label.text = name
        label.textColor = .label
        label.setFont(with: 12)
        
        // add label
        self.addSubview(label)
        
        // configure constraints
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
} // User avitar image
class HeaderDetail: UIView {
    
    var Album: Album?
    let img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        heightAnchor.constraint(equalToConstant: 425).isActive = true
//        backgroundColor = UIColor.red/
        
    }
    required init?(coder: NSCoder) {
        fatalError("There was an error")
    }
    func config(album: Album){
        
        self.addSubview(trackOptionBtn)
        trackOptionBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        trackOptionBtn.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        SetupAlbumCover(album: album)
////
//        self.addSubview(artistLabel)
//        artistLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
//        artistLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20).isActive = true
//        artistLabel.text = album.Artist
//        artistLabel.textColor = .white
////
        self.addSubview(trackLabel)
        trackLabel.leadingAnchor.constraint(equalTo: img.leadingAnchor).isActive = true
        trackLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20).isActive = true
        trackLabel.textColor = .white

        setupConstraints(top: self.topAnchor, topConst: 20, leading: self.leadingAnchor, leadingConst: 50)
        
        dollarBTn.setTitle(" 9.99", for: .normal)
        
        self.addSubview(dollarBTn)
        dollarBTn.translatesAutoresizingMaskIntoConstraints = false
        dollarBTn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        dollarBTn.bottomAnchor.constraint(equalTo: trackLabel.bottomAnchor).isActive = true
    }
    func SetupAlbumCover(album: Album) -> Void {
        img.image = UIImage(named: album.Image)
        img.layer.cornerRadius = 10
//        self.contentMode = .left
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true

        self.addSubview(img)
        
        img.translatesAutoresizingMaskIntoConstraints = false
        img.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        img.topAnchor.constraint(equalTo: trackOptionBtn.bottomAnchor, constant: 20).isActive = true
        img.heightAnchor.constraint(equalToConstant: 315).isActive = true
        img.widthAnchor.constraint(equalToConstant: 335).isActive = true
    }

    public func setupConstraints(
        top: NSLayoutAnchor<NSLayoutYAxisAnchor>?, topConst: CGFloat?,
        leading: NSLayoutAnchor<NSLayoutXAxisAnchor>?, leadingConst: CGFloat?) -> Void {

        self.topAnchor.constraint(equalTo: top!, constant: topConst!).isActive = true
        self.leadingAnchor.constraint(equalTo: leading!, constant: leadingConst!).isActive = true
    }

    let detailImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mac")
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.widthAnchor.constraint(equalToConstant: 25).isActive = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let artistLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let trackLabel: UILabel = {
        let label = UILabel()
        label.text = "Drive slow"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        return label
    }()
    let trackOptionBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .lightGray
        return btn
    }()
    let dollarBTn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "dollarsign.circle"), for: .normal)
        btn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.3)
        return btn
    }()
    let footer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 450))
//        view.backgroundColor = .red
        return view
    }()
    let footerlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "helvetica Neue", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    let moreMusicScrollContainer: UIScrollView = {
        let scrollview = UIScrollView()
//        scrollview.backgroundColor = .green
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.heightAnchor.constraint(equalToConstant: 225).isActive = true
        scrollview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return scrollview
    }()
    let moreMusicStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        view.distribution = .fillEqually
        view.alignment = .leading
        view.axis = .horizontal
//        view.backgroundColor = .blue
        view.heightAnchor.constraint(equalToConstant: 225).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1550).isActive = true
        return view
    }()
    let relatedArtistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You May Also Like"
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        return label
    }()
    let relatedArtistSV: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
//        view.backgroundColor = .green
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return view
    }()
    let relatedArtistStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 0
        view.distribution = .fillEqually
        view.alignment = .leading
        view.axis = .horizontal
        view.heightAnchor.constraint(equalToConstant: 125).isActive = true
        view.widthAnchor.constraint(equalToConstant: 900).isActive = true
//        view.backgroundColor = .red
        return view
    }()
} // Track header
class DetailFooterDetail: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 400).isActive = true
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    func configure(){
//        self.addSubview(container)
//        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
}

class UserAViReleaseAvi: UIView{

    private var image: UIImageView?
    private var usernameLabel: UILabel?

    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        self.heightAnchor.constraint(equalToConstant: 115).isActive = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    required init(coder: NSCoder) {
        fatalError("")
    }

    func setupAvi(artist: Artist){

    }

} // Small artist AVI for scrollable view
class Genres: MediumSlider {
    
    let img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder: NSCoder) {
        fatalError("")
    }
    
    func setupImage(image: UIImage){
        img.image = image
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
    }
}
//class Playlist: Genres {}

class MediumTrackComponent: UIView {
    private var image: UIImageView?
    private var artistNamelabel: UILabel?
    private var albumNameLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("There was an error")
    }
    func setupAlbum(image: UIImage, artist: String, name: String){
        setupImage(image: image)
        setupLabels(artist: artist, name: name)
        setupConstrains()
    }
    
    private func setupImage(image: UIImage){
        self.image = UIImageView()
        self.image?.image = image
        self.image?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.image?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.image?.layer.cornerRadius = 10
        self.image?.clipsToBounds = true
        
        self.addSubview(self.image!)
    }
    
    private func setupLabels(artist: String, name: String){
     
        self.artistNamelabel = UILabel()
        self.artistNamelabel?.text = artist
        self.artistNamelabel?.textColor = .white
        self.artistNamelabel?.translatesAutoresizingMaskIntoConstraints = false
        self.artistNamelabel?.font = UIFont(name: "Helvetica Neue", size: 10)
        self.artistNamelabel?.font = UIFont.boldSystemFont(ofSize: 10)
        
        self.addSubview(self.artistNamelabel!)
        
        self.albumNameLabel = UILabel()
        self.albumNameLabel?.text = name
        self.albumNameLabel?.textColor = .white
        self.albumNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.albumNameLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        self.albumNameLabel?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.addSubview(albumNameLabel!)
    }

    private func setupConstrains(){
        setupImageConstraints()
        setupArtistNameConstraints()
        setupAlbumNameConstraints()
    }
    
    private func setupImageConstraints(){
        self.image?.translatesAutoresizingMaskIntoConstraints = false
        self.image?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.image?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupArtistNameConstraints(){
        self.artistNamelabel?.translatesAutoresizingMaskIntoConstraints = false
        self.artistNamelabel?.topAnchor.constraint(equalTo: self.image!.bottomAnchor, constant: 10).isActive = true
        self.artistNamelabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    private func setupAlbumNameConstraints(){
        self.albumNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.albumNameLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.albumNameLabel?.topAnchor.constraint(equalTo: self.artistNamelabel!.bottomAnchor, constant: 5).isActive = true
    }
} // Track image with label
class MediumAlbumComponent: UIView {
    private var image: UIImageView?
    private var artistNamelabel: UILabel?
    private var albumNameLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        self.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("There was an error")
    }
    func setupAlbum(image: UIImage, artist: String, name: String){
        setupImage(image: image)
        setupLabels(artist: artist, name: name)
        setupConstrains()
    }
    
    private func setupImage(image: UIImage){
        self.image = UIImageView()
        self.image?.image = image
        self.image?.heightAnchor.constraint(equalToConstant: 180).isActive = true
        self.image?.widthAnchor.constraint(equalToConstant: 180).isActive = true
        self.image?.layer.cornerRadius = 10
        self.image?.clipsToBounds = true
        
        self.addSubview(self.image!)
    }
    
    private func setupLabels(artist: String, name: String){
     
        self.artistNamelabel = UILabel()
        self.artistNamelabel?.text = artist
        self.artistNamelabel?.textColor = .white
        self.artistNamelabel?.translatesAutoresizingMaskIntoConstraints = false
        self.artistNamelabel?.font = UIFont(name: "Helvetica Neue", size: 10)
        self.artistNamelabel?.font = UIFont.boldSystemFont(ofSize: 10)
        
        self.addSubview(self.artistNamelabel!)
        
        self.albumNameLabel = UILabel()
        self.albumNameLabel?.text = name
        self.albumNameLabel?.textColor = .white
        self.albumNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.albumNameLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        self.albumNameLabel?.widthAnchor.constraint(equalToConstant: 175).isActive = true
        self.addSubview(albumNameLabel!)
    }

    private func setupConstrains(){
        setupImageConstraints()
        setupArtistNameConstraints()
        setupAlbumNameConstraints()
    }
    
    private func setupImageConstraints(){
        self.image?.translatesAutoresizingMaskIntoConstraints = false
        self.image?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.image?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupArtistNameConstraints(){
        self.artistNamelabel?.translatesAutoresizingMaskIntoConstraints = false
        self.artistNamelabel?.topAnchor.constraint(equalTo: self.image!.bottomAnchor, constant: 10).isActive = true
        self.artistNamelabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    private func setupAlbumNameConstraints(){
        self.albumNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.albumNameLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.albumNameLabel?.topAnchor.constraint(equalTo: self.artistNamelabel!.bottomAnchor, constant: 5).isActive = true
    }
} // Album image with labels
class TrackStrip: UIView{
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        self.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(artist: String, trackName: String, albumImg: String){
        self.addSubview(trackImg)
        trackImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        trackImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(trackLabel)
        trackLabel.leadingAnchor.constraint(equalTo: trackImg.leadingAnchor, constant: 100).isActive = true
        trackLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(trackImg)
        trackImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        trackImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trackImg.image = UIImage(named: albumImg)
        
        self.addSubview(trackLabel)
        trackLabel.text = trackName
        trackLabel.leadingAnchor.constraint(equalTo: trackImg.leadingAnchor, constant: 100).isActive = true
        trackLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        
        self.addSubview(artistLabel)
        artistLabel.topAnchor.constraint(equalTo: trackLabel.bottomAnchor).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo: trackLabel.leadingAnchor).isActive = true
        artistLabel.text = artist
    }
    
    let trackImg: UIImageView = {
        let img = UIImageView()
        img.heightAnchor.constraint(equalToConstant: 50).isActive = true
        img.widthAnchor.constraint(equalToConstant: 50).isActive = true
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 10)
        label.textColor = .white
        return label
    }()
} // Track list with image and label

// Tableview cells
class Track: UITableViewCell {
    static let reuseIdentifier: String = "track"
    
    let img = UIImageView()
    let label = UILabel()
    let dollarBTn = UIButton()
    
    func configure(indexPath: Int, image: String, trackName: String){
        contentView.addSubview(container)
        
        // image config
        img.heightAnchor.constraint(equalToConstant: 50).isActive = true
        img.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        img.image = UIImage(named: image)
        container.addSubview(img)
        
        // image constraints
        img.translatesAutoresizingMaskIntoConstraints = false
        img.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        img.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        
        // label config
        label.text = trackName
    
        contentView.addSubview(label)
        
        // label constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.textColor = .white
        
        self.addSubview(dollarBTn)
        dollarBTn.setTitle(" 0.99", for: .normal)
        dollarBTn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        dollarBTn.setImage(UIImage(systemName: "dollarsign.circle"), for: .normal)
        dollarBTn.tintColor = UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.3)
        
        dollarBTn.translatesAutoresizingMaskIntoConstraints = false
        dollarBTn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        dollarBTn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    let container: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
} //

// Buttons
class LargePrimaryButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setupButton(label: String){
        self.setTitle(label, for: .normal)
        self.setTitleColor(UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 1), for: .normal)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
    }
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

// Extentions
extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
//        backgroundColor = .white
//        textColor = .black
        bottomLine.cornerRadius = 25
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
extension UILabel {
    func setFont(with size: CGFloat){
        font = UIFont(name: "Helvetica Neue", size: size)
    }
    func setBoldFont(with size: CGFloat){
        font = UIFont.boldSystemFont(ofSize: size)
    }
}
