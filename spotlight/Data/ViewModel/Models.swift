//
//  MusicModels.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import Foundation

struct Artist: Decodable {
    var Id: String
    var Name: String
    var ImageUrl: String
    var IsVerified: Bool
}

struct Song: Decodable {
    var Id: String
    var Title: String
    var ArtistId: String
    var Artists: String
    var Image: String
    var AlbumId: String
}

struct Album: Decodable {
    var Id: String
    var Name: String
    var ArtistId: String
    var Image: String
    var Artist: String
}

struct Playlist: Decodable {
    var Id: String
    var Name: String
    var Image: String
    var Songs: [Song]
}




// Home section models
struct Sections: Codable, Hashable {
    var id: String
    var type: String
    var tagline: String
    var items: [Catalog]
}

struct Catalog: Codable, Hashable {
    var id: String
    var title: String
    var artist: String
    var imgURL: String
    var playCount: String?
}
//

// Track overview models
struct TrackDetail: Codable, Hashable {
    var id: String
    var type: String
    var tagline: String
    var artist: String
    var title: String
    var artistImgURL: String?
    var imageURL: String?
    var items: [TrackItem]
}

struct TrackItem: Codable, Hashable {
    var id: String
    var title: String
    var artist: String
    var imageURL: String
}

//

struct Player: Codable, Hashable {
    var id: String
    var type: String
    var title: String
    var imageURL: String
//    var backgroundVideoURL: String?
    var items: [Queue]
//    var saved: Bool
}
struct Queue: Codable, Hashable{
    var id: String
    var title: String
    var artist: String
    var imgURL: String
//    var saved: Bool
}

struct User: Decodable{
    var id: String?
    var username: String
    var imgURL: String?
}
