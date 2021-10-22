//
//  MusicModels.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import Foundation

struct LibObject: Codable, Hashable {
    var id: String
    var type: String
    var tagline: String?
    var items: [LibItem]?
}

struct LibItem: Codable ,Hashable{
    var id: String
    var type: String?
    var trackNum: String?
    var title: String?
    var artistId: String?
    var albumId: String?
    var artist: String?
    var imageURL: String
    var playCount: String?
    var name: String?
//    var followers: String?
//    var listeners: String?
//    var bio: String?
//    var dateJoined: String?
}

struct AlbumDetail: Codable, Hashable {
    var id: String
    var type: String
    var artist: String
    var title: String
    var artistImgURL: String?
    var imageURL: String?
    var items: [AlbumItems]?
}

struct AlbumItems: Codable, Hashable {
    var id: String
    var type: String?
    var trackNum: String?
    var title: String?
    var artistId: String?
    var artist: String?
    var albumId: String?
    var imageURL: String?
    var name: String?
    var isVerified: Bool?
    var playCount: String?
}

struct Artist: Codable, Hashable {
    var id: String
    var name: String
    var imageURL: String
    var isVerified: Bool
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
struct DetailSection: Codable, Hashable {
    var id: String
    var type: String
    var artist: String
    var items: [AlbumDetail]
}



// Artist Profile data model
struct ArtistDetail: Codable, Hashable{
    var id: String
    var type: String
    var username: String
    var imageURL: String
    var sections: [ProfileSections]
}

struct ProfileSections: Codable, Hashable{
    var id: String
    var type: String
    var tagline: String
    var items: [ProfileItem]
}

struct ProfileItem: Codable, Hashable {
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
