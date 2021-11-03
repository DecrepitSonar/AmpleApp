//
//  NetworkManager.swift
//  spotlight
//
//  Created by Robert Aubow on 7/23/21.
//

import Foundation
import Combine

enum NetworkError: Error{
    case notfound
    case sucess
    case servererr
}
 
class NetworkManager {
    
//    static let baseURL = "https://spotlight-ap.herokuapp.com/api/v1/"
    static let baseURL = "http://localhost:8080/api/v1/"
    
    // Home page content
    static func loadHomeContent(completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)")
        
        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.servererr))
//                    print(error)
                }
                
                guard let httpresponse = response as? HTTPURLResponse else {
//                    print(response)
                    return
                }
                
                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
                    completion(.failure(.servererr))
//                    print()
                    return
                }
                
                let decoder = JSONDecoder()
                
                let dataResponse = try? decoder.decode([LibObject].self, from: data!)
                
//                print(dataResponse)
                completion(.success(dataResponse!))
            }
        }.resume()
        
    }
    //User
//    static func login(user: User, completion: @escaping (Result<User, NetworkError>) -> Void){} // Authenticate user credentials
//    static func register(user: User, completion: @escaping (Result<User, NetworkError>) -> Void){} // Register user
//    static func getUser(user: User, completion: @escaping (Result<User, NetworkError>) -> Void){} // Get user data
//    static func getSaved<T: Decodable>(user: User, completion: @escaping (Result<T, NetworkError>) -> Void){} // Get user saved data
//    static func getFollowing(user: User, completion: @escaping (Result<[User], NetworkError>) -> Void){} // Get user following
//    static func getFollowers(user: User, completion: @escaping (Result<[User], NetworkError>) -> Void){} // Get user followers
//    static func logout(user: User, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // Unauthenticate user
//
//    // Artists
    static func getArtistsProfileData(artistId: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)artist?id=\(artistId)")
        
//        print("Artist id: ", artistId)
//        print(url)

        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.servererr))
                    print(error!)
                }

                guard let httpresponse = response as? HTTPURLResponse else {
                    print(response!)
                    return
                }

                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
                    print(httpresponse.mimeType!)
                    completion(.failure(.servererr))
                    return
                }

                let decoder = JSONDecoder()

                let dataResponse = try? decoder.decode([LibObject].self, from: data!)

//                print(dataResponse!)
                completion(.success(dataResponse!))
            }
        }.resume()

    } // Get Featured Artists
    
//    static func getArtists(completion: @escaping (Result<[Artist], NetworkError>) -> Void){
//        let url = URL(string: "\(baseURL)/artists")
//
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//            DispatchQueue.main.async {
//                if error != nil {
//                    completion(.failure(.servererr))
////                    print(error)
//                }
//
//                guard let httpresponse = response as? HTTPURLResponse else {
////                    print(response)
//                    return
//                }
//
//                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                    completion(.failure(.servererr))
//                    return
//                }
//
//                let decoder = JSONDecoder()
//
//                let dataResponse = try? decoder.decode([Artist].self, from: data!)
//
//                print(dataResponse!)
//                completion(.success(dataResponse!))
//            }
//        }.resume()
//
//    } // Get multiple Artists
//    static func getSingleArtist(with url: String, id: String, completion: @escaping (Result<Artist, NetworkError>) -> Void){} // Get one artist using ID
//    static func followArtist(with url: String, id: String, completion: @escaping () -> Void){} // add artist to following
//    static func unFollowArtist(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // remove artist from following
    
    // Albums
    static func getAlbum(id: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)album?albumId=\(id)")
        print(id)
                      
        URLSession.shared.dataTask(with: url!){ data, response, error in
                   DispatchQueue.main.async {
                       if error != nil {
                           completion(.failure(.servererr))
//                           print(error)
                       }
       
                       guard let httpresponse = response as? HTTPURLResponse else {
//                           print(response)
                           return
                       }
       
                       guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
                           completion(.failure(.servererr))
                           return
                       }
                    do{
                        let decoder = JSONDecoder()
        
                        let dataResponse = try decoder.decode([LibObject].self, from: data!)
                        completion(.success(dataResponse))
                    }
                    catch{
                        print(error)
                    }
                       
                       
                   }
               }.resume()

    } // Get featured albums for discvoer tab
    static func getAlbums(completion: @escaping (Result<[Album], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/albums")
        
        URLSession.shared.dataTask(with: url!){ data, response, error in
                   DispatchQueue.main.async {
                       if error != nil {
                           completion(.failure(.servererr))
       //                    print(error)
                       }
       
                       guard let httpresponse = response as? HTTPURLResponse else {
       //                    print(response)
                           return
                       }
       
                       guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
                           completion(.failure(.servererr))
                           return
                       }
       
                       let decoder = JSONDecoder()
       
                       let dataResponse = try? decoder.decode([Album].self, from: data!)
       
//                       print(dataResponse!)
                       completion(.success(dataResponse!))
                   }
               }.resume()
    }
    static func getAlbumsOfArtist(with url: String, artistId: String, completion: @escaping (Result<[Album], NetworkError>) -> Void){} // Get all albums of artist with ID
//    static func getAlbum(id: String, completion: @escaping (Result<Album, NetworkError>) -> Void){
//        
//        let url = URL(string: "\(baseURL)/albums?albumId=\(id)")
//        
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//                  DispatchQueue.main.async {
//                      if error != nil {
//                          completion(.failure(.servererr))
//      //                    print(error)
//                      }
//      
//                      guard let httpresponse = response as? HTTPURLResponse else {
//      //                    print(response)
//                          return
//                      }
//      
//                      guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                          completion(.failure(.servererr))
//                          return
//                      }
//      
//                      let decoder = JSONDecoder()
//      
//                      let dataResponse = try? decoder.decode(Album.self, from: data!)
//      
////                      print(dataResponse!)
//                      completion(.success(dataResponse!))
//                  }
//              }.resume()
//        
//    } // Get one album with ID
    static func saveAlbum(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // add albums to saved
    static func unsaveAlbum(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // removed album from saved
    
    // Tracks
//    static func getTracks(albumId: String, completion: @escaping (Result<[Song], NetworkError>) -> Void){
//        let url = URL(string: "\(baseURL)/tracks?albumId=\(albumId)")
//        
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//                  DispatchQueue.main.async {
//                      if error != nil {
//                          completion(.failure(.servererr))
//      //                    print(error)
//                      }
//      
//                      guard let httpresponse = response as? HTTPURLResponse else {
//      //                    print(response)
//                          return
//                      }
//      
//                      guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                          completion(.failure(.servererr))
//                          return
//                      }
//      
//                      let decoder = JSONDecoder()
//      
//                      let dataResponse = try? decoder.decode([Song].self, from: data!)
//      
//                      print("Tracks", dataResponse!)
//                      completion(.success(dataResponse!))
//                  }
//              }.resume()
//        
//    } // get track with ID
//    static func getTrack(trackId: String, completion: @escaping (Result<Song, NetworkError>) -> Void){
//        
//        let url = URL(string: "\(baseURL)/tracks?trackId=\(trackId)")
//        
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//            DispatchQueue.main.async {
//                if error != nil {
//                    completion(.failure(.servererr))
////                    print(error)
//                }
//                
//                guard let httpresponse = response as? HTTPURLResponse else {
////                    print(response)
//                    return
//                }
//                
//                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                    completion(.failure(.servererr))
//                    return
//                }
//                
//                let decoder = JSONDecoder()
//                
//                let dataResponse = try? decoder.decode(Song.self, from: data!)
//                
//                print(dataResponse!)
//                completion(.success(dataResponse!))
//            }
//        }.resume()
//        
//    } // get track with ID
//    static func getTrackHistory(completion: @escaping (Result<[Song], NetworkError>) -> Void){
//        
//        let url = URL(string: "\(baseURL)/trackhistory")
//        
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//            DispatchQueue.main.async {
//                if error != nil {
//                    completion(.failure(.servererr))
////                    print(error)
//                }
//                
//                guard let httpresponse = response as? HTTPURLResponse else {
////                    print(response)
//                    return
//                }
//                
//                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                    completion(.failure(.servererr))
//                    return
//                }
//                
//                let decoder = JSONDecoder()
//                
//                let dataResponse = try? decoder.decode([Song].self, from: data!)
//                
////                print(dataResponse!)
//                completion(.success(dataResponse!))
//            }
//        }.resume()
//        
//    } // get all items in track history
//    static func saveTrack(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // add track to saved
//    static func removeSaved(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // remove track from saved
//    static func getNewTracks(completion: @escaping (Result<[Album], NetworkError>) -> Void){
//        
//        let url = URL(string: "\(baseURL)/freshdrops")
//        
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//                  DispatchQueue.main.async {
//                      if error != nil {
//                          completion(.failure(.servererr))
//      //                    print(error)
//                      }
//      
//                      guard let httpresponse = response as? HTTPURLResponse else {
//      //                    print(response)
//                          return
//                      }
//      
//                      guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                          completion(.failure(.servererr))
//                          return
//                      }
//      
//                      let decoder = JSONDecoder()
//      
//                      let dataResponse = try? decoder.decode([Album].self, from: data!)
//      
//                      print(dataResponse!)
//                      completion(.success(dataResponse!))
//                  }
//              }.resume()
//    }
//    
//    // Playlists
//    static func getPlaylist(with url: String, id: String){} // Get playlist with id
//    static func getPlaylists(completion: @escaping (Result<[Playlist], NetworkError>) -> Void){
//        let url = URL(string: "\(baseURL)/playlists")
//        
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//                    DispatchQueue.main.async {
//                        if error != nil {
//                            completion(.failure(.servererr))
//        //                    print(error)
//                        }
//        
//                        guard let httpresponse = response as? HTTPURLResponse else {
//        //                    print(response)
//                            return
//                        }
//        
//                        guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                            completion(.failure(.servererr))
//                            return
//                        }
//        
//                        let decoder = JSONDecoder()
//        
//                        let dataResponse = try? decoder.decode([Playlist].self, from: data!)
//        
////                        print(dataResponse!)
//                        completion(.success(dataResponse!))
//                    }
//                }.resume()
//        
//    } // Get all playlists
    static func savePlaylist(with url: String, id: String){} // add playlist to saved
    
    // Genres
    static func getGenres(with url: String){} // Get all Genres
    static func getGenre(with url: String, id: String){} // Get Genre with id
    
    // images
    static func getImage(with url: String, imgUrl: String){} // Get image with ImgUrl
    
    // GET
//    static func GET<T>( url: URL, Type: T , completion: @escaping (Result<T, NetworkError>) -> Void ){
//
//        URLSession.shared.dataTask(with: url){ data, response, error in
//            DispatchQueue.main.async {
//                if error != nil {
//                    completion(.failure(.servererr))
////                    print(error)
//                }
//
//                guard let httpresponse = response as? HTTPURLResponse else {
////                    print(response)
//                    return
//                }
//
//                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                    completion(.failure(.servererr))
//                    return
//                }
//
//                let decoder = JSONDecoder()
//
//                let dataResponse = try? decoder.decode(T.self, from: data!)
//
//                print(dataResponse!)
//                completion(.success(dataResponse!))
//            }
//        }.resume()
//    }
    
    // POST
    
    // PUT
    
    // DELETE
    static func readJSONFromFile(fileName: String) -> [LibObject]?
      {
          var json: [LibObject]?
        let decoder = JSONDecoder()
          if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
              do {
                  let fileUrl = URL(fileURLWithPath: path)
                  // Getting data from JSON file using the file URL
                  let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
                json = try? decoder.decode([LibObject].self, from: data)
              } catch {
                  // Handle error here
              }
          }
//        print("Section: ", json)
        
          return json
      }
    
//   ?
    
    static func readProfileData(filename: String, id: String) -> [LibObject]{
        print("getting data")
        
        var json: [LibObject]?
        let decoder = JSONDecoder()
        
        if let path = Bundle.main.path(forResource: filename, ofType: "json"){
            do {
                print("not nil")
                let fileURL = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                
                 json = try decoder.decode([LibObject].self, from: data)
                
//                print(json!)
            }
            catch{
//                print(error)
            }
        }
        
//        print(json!)
        
        return json!
    }
    
    
}
