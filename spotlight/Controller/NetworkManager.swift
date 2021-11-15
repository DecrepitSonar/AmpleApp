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
    
    static let baseURL = "https://spotlight-ap.herokuapp.com/api/v1/"
//    static let baseURL = "http://localhost:8080/api/v1/"
    
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

//    // Artists
    static func getArtistsProfileData(artistId: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)artist?id=\(artistId)")
        
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

    }
    
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

    }
    
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
    
//    static func saveAlbum(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // add albums to saved
//    static func unsaveAlbum(with url: String, id: String, completion: @escaping (Result<Bool, NetworkError>) -> Void){} // removed album from saved

    // images
    static func getImage(with url: String, imgUrl: String){} // Get image with ImgUrl
    
    static func getAudioTrack(track: String, completion: @escaping (Result<Data, NetworkErr>) -> Void){
    
        let url = URL(string: "\(baseURL)track?audioURL=\(track)")
//        let request = URLRequest(url: url!)
        
//        print(url)
        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.ServerError))
//                    print(error)
                }

                guard let httpresponse = response as? HTTPURLResponse else {
//                    print(response)
                    return
                }
//                print( httpresponse)
                guard let mimeType = httpresponse.mimeType, mimeType == "application/octet-stream" else {
                    completion(.failure(.ServerError))
//                    print("mime err")
                    return
                }

                completion(.success(Data(data!)))
            }
        }.resume()
            
    }
    
    static func getTracks(completion: @escaping (Result<[Track], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)tracks")
    
                      
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
        
                        let dataResponse = try decoder.decode([Track].self, from: data!)

                        completion(.success(dataResponse))
                    }
                    catch{
                        print(error)
                    }
                   }
               }.resume()
    }
    static func getTrack(id: String, completion: @escaping (Result<Track, NetworkError>) -> Void) {
        
        let url = URL(string: "\(baseURL)track?id=\(id)")
        print("requested id:", id)
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
        
                        let dataResponse = try decoder.decode(Track.self, from: data!)

                        completion(.success(dataResponse))
                    }
                    catch{
                        print(error)
                    }
                   }
               }.resume()
    }
    
    static func getRandomAudioTrack( completion: @escaping (Result<Track, NetworkError>) -> Void){
    
        let url = URL(string: "\(baseURL)track?isRandom=true")
//        let request = URLRequest(url: url!)
        
//        print(url)
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
        
                        let dataResponse = try decoder.decode(Track.self, from: data!)

                        completion(.success(dataResponse))
                    }
                    catch{
                        print(error)
                    }
                   }
               }.resume()
        
    }
    
}
