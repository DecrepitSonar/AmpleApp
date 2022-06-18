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
    var joinDate: String
}

struct LoginCredentials: Codable{
    var username: String
    var password: String
}

struct VideoSectionModel: Codable, Hashable {
    var id: String
    var type: String
    var tagline: String
    var items: [VideoItemModel]
}

struct VideoItemModel: Codable, Hashable {
    var id: String
    var videoURL: String
    var posterURL: String?
    var title: String
    var artist: String
    var artistImageURL: String?
    var albumId: String?
    var views: Int32
}

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
    var posterImage: String?
    var artist: String?
    var name: String?
    var imageURL: String?
    var audioURL: String?
    var albumId: String?
    var playCount: Int32?
    var subscribers: Int32?
    var isVerified: Bool?
    var joinDate: String?
    var videoURL: String?
    var posterURL: String?
}

struct Item: Codable, Hashable{
    var id: String
    var type: String
    var title: String
    var audioURL: String?
    var name: String
    var imageURL: String?
    var videoURL: String?
    var posterImageURL: String?
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
    var videoId: String?
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

struct Playlist: Codable {
    var id: String
    var title: String
    var type: String
    var userId: String
    var tracks: [Track]
    var imageURL: String
}

//
//{"_id":{"$oid":"62686a8bb28cb663b530ce7d"},"id":"5c3e07656efc75a2a365a6103415619eff58d412","videoURL":"https://prophile.nyc3.digitaloceanspaces.com/Videos/f8856321095006adba848aa554353a5c4911b933.mp4","posterURL":"Capture-25","title":"Nights Like This (feat. Ty Dolla $ign) [Official Music Video]","artist":"Kehlani","albumId":"","views":{"$numberInt":"413"},"releaseDate":{"$date":{"$numberLong":"1651012678398"}}}
