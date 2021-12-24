//
//  MusicModels.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import Foundation

struct UserCredentials: Decodable {
    var username: String
    var apiKey: String
}

struct credentials: Codable{
    var username: String
    var password: String
}

struct LibObject: Codable, Hashable {
    var id: String
    var artistId: String?
    var type: String
    var title: String?
    var tagline: String?
    var name: String?
    var imageURL: String?
    var artistImgURL: String?
    var items: [LibItem]?
}

struct LibItem: Codable ,Hashable{
    var id: String
    var type: String?
    var trackNum: String?
    var title: String?
    var artistId: String?
    var albumId: String?
    var imageURL: String
    var playCount: Int32?
    var name: String?
//    var followers: String?
    var listeners: Int32?
    var isVerified: Bool?
//    var bio: String?
//    var dateJoined: String?
    var audioURL: String?
}

struct AlbumDetail: Codable, Hashable {
    var id: String
    var type: String
    var artist: String

    
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
    
    var playCount: Int?
}

struct Artist: Codable, Hashable {
    var id: String
    var name: String
    var imageURL: String
    var isVerified: Bool
}

struct Track: Decodable {
    var id: String
    var title: String
    var artistId: String
    var name: String
    var imageURL: String
    var albumId: String
    var audioURL: String?
}

struct Album: Decodable {
    var Id: String
    var Name: String
    var ArtistId: String
    var Image: String
    var Artist: String
}
//
//struct Playlist: Decodable {
//    var Id: String
//    var Name: String
//    var Image: String
//    var Songs: [Song]
//}

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

struct SearchObj: Codable, Hashable{
    var id: String
    var type: String
    var tagline: String
    var items: [SearchItem]
}

struct SearchItem: Codable, Hashable{
    var id: String
    var type: String
    var title: String
    var name: String?
    var imageURL: String?
    var count: String?
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

struct settings{
    let name: String
    let image: String
    let description: String
}
