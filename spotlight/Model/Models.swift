//
//  MusicModels.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import Foundation

struct UserData: Decodable {
    var id: String
    var username: String
    var password: String
    var email: String
    var subscribed: [String]
    var joinDate: String
    var savedAlbums: [Album]
    var savedTracks: [Track]
    var playlists: [Album]
    var listeningHistory: [Track]
}

struct LoginCredentials: Codable{
    var username: String
    var password: String
}
//
//struct LibObject: Codable, Hashable {
//    var id: String
//    var artistId: String?
//    var type: String
//    var title: String?
//    var tagline: String?
//    var name: String?
//    var imageURL: String?
//    var artistImgURL: String?
//    var items: [LibItem]?
//}

struct LibObject: Codable, Hashable {
    var id: String
    var type: String
    var tagline: String?
    var items: [LibItem]?
    var name: String?
    var artistImgURL: String?
    var title: String?
    var imageURL: String?
    var artistId: String?
    var releaseDate: String?
}

struct LibItem: Codable, Hashable {  
    var id: String
    var trackNum: Int?
    var genre: String?
    var type: String?
    var title: String?
    var artistId: String?
    var name: String?
    var imageURL: String
    var audioURL: String?
    var albumId: String?
    var playCount: Int32?
//    var followers: String?
    var subscribers: Int32?
    var isVerified: Bool?
//    var bio: String?
    var joinDate: String?
//    var audioURL: String?
}

struct Album: Codable, Hashable {
    var id: String
    var type: String
    var tagline: String?
    var items: [Track]?
    var name: String?
    var artistImgURL: String?
    var title: String?
    var imageURL: String?
    var artistId: String?
    var releaseDate: String?
}

struct AlbumItem: Codable, Hashable {
    var id: String
    var type: String?
    var trackNum: UInt?
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
    var type: String
    var name: String
    var imageURL: String
    var isVerified: Bool
    var joinDate: String
    var subscribers: UInt32
}

struct Track: Codable, Hashable {
    var id: String
    var type: String?
    var trackNum: UInt?
    var title: String
    var artistId: String
    var name: String
    var imageURL: String
    var albumId: String
    var audioURL: String?
    var playCount: Int?
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

struct ProfileItem: Codable, Hashable {
    var genre: String
    var about: String
    var label: String
    var country: String
}

struct ProfileObject: Codable, Hashable{
    var id: String
    var type: String
    var name: String
    var artistId: String
    var imageURL: String
    var bio: ProfileItem?
    var joinDate: String
    var subscribers: UInt32
    var isVerified: Bool
    var items: [LibObject]
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
