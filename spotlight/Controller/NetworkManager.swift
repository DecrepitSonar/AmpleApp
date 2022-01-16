//
//  NetworkManager.swift
//  spotlight
//
//  Created by Robert Aubow on 7/23/21.
//

import Foundation
import Combine
import CoreMedia
import AVFoundation

enum NetworkError: Error{
    case notfound
    case sucess
    case servererr
    case authenticationError
}
 
class NetworkManager {
    
//    static let baseURL = "https://spotlight-ap.herokuapp.com/api/v1"
    static let baseURL = "http://localhost:8080/api/v1"
//    static let baseURL = "https://app-server-savi4.ondigitalocean.app/api/v1"
    
    static let CDN = "https://prophile.nyc3.digitaloceanspaces.com/";
    static func authenticateUser(user: credentials, completion: @escaping (Result<UserCredentials, NetworkError>) -> Void){
        
        let url = URL(string: "\(baseURL)/authenticate")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        print(user)
        
        guard let credentials = try? JSONEncoder().encode(user) else {
            print("could not encode user credentials for authentication request")
            return
        }
        
        request.httpBody = credentials
        
        DispatchQueue.main.async {
            let task = URLSession.shared.uploadTask(with: request, from: credentials) { data, response, error in
                if error != nil {
//                    print( error)
                }
                
                guard let response = response as? HTTPURLResponse else {
    //                print(response)
                    return
                }
                
//                print(response)
                
                switch(response.statusCode){
                case 200:
                    
                    print("reponse ok")
                    
                    do {
                        let data = try JSONDecoder().decode(UserCredentials.self, from: data!)
                        print(data)
                        completion(.success(data))
                    }
                    catch{
                        return
                    }
                    
                case 404:
                    completion(.failure(.notfound))
    
                case 500:
                    completion(.failure(.servererr))
    
                case 403:
                    completion(.failure(.authenticationError))
    
                default:
                    print("Requst completed successfully")
                }
    //
               

            }
            
            task.resume()
        }
        
    }
//    static func loadHomePageContent(completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
//        let url = URL(string: "\(baseURL)/home")
//
//        URLSession.shared.dataTask(with: url!){ data, response, error in
//            DispatchQueue.main.async {
//                if error != nil {
//                    completion(.failure(.servererr))
//                    print(error)
//                }
//
//                guard let httpresponse = response as? HTTPURLResponse else {
////                    print(response)
//                    return
//                }
//
//                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
//                    completion(.failure(.servererr))
////                    print()
//                    return
//                }
//
//                let decoder = JSONDecoder()
//
//                let dataResponse = try? decoder.decode([LibObject].self, from: data!)
//
//                print(dataResponse)
//                completion(.success(dataResponse!))
//            }
//        }.resume()
//
//    }
    static func loadHomePageContent(userId: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/home?user=\(userId)")
        
        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
//                    completion(.failure(.servererr))
                    print(error)
                }
                
                guard let httpresponse = response as? HTTPURLResponse else {
                    
                    return
                }
                
                print(httpresponse)
                guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
                    completion(.failure(.servererr))
//                    print()
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let dataResponse = try decoder.decode([LibObject].self, from: data!)
                    print(dataResponse)
                    completion(.success(dataResponse))
                }
                catch{
                    print(error)
                }
                
                
                
                
            }
        }.resume()
        
    }
    static func getArtistsProfileData(artistId: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/artist?id=\(artistId)")
        
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

//                print(dataResponse)
                completion(.success(dataResponse!))
            }
        }.resume()

    }
    static func getAlbum(id: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/album?albumId=\(id)")
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
       
                       print(httpresponse)
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
    static func getImage(with url: String, completion: @escaping (Result<Data, NetworkErr>) -> Void){
        let url = URL(string: "\(CDN)images/\(url).jpg")
        
        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.ServerError))
                    print(error)
                }

                guard let httpresponse = response as? HTTPURLResponse else {
                    print(response)
                    return
                }
                print( httpresponse)
                guard let mimeType = httpresponse.mimeType, mimeType == "image/jpeg" else {
                    completion(.failure(.ServerError))
//                    print("mime err")
                    return
                }

                completion(.success(Data(data!)))
            }
        }.resume()
        
    } // Get image with ImgUrl
    
    // Audio
    static func getAudioTrack(track: String, completion: @escaping (Result<Data, NetworkErr>) -> Void){
    
        let url = URL(string: "\(CDN)audio/\(track).mp3")
        
        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.ServerError))
                    print(error)
                }

                guard let httpresponse = response as? HTTPURLResponse else {
                    print(response)
                    return
                }
                print( httpresponse)
                guard let mimeType = httpresponse.mimeType, mimeType == "audio/mpeg" else {
                    completion(.failure(.ServerError))
//                    print("mime err")
                    return
                }

                completion(.success(Data(data!)))
            }
        }.resume()
            
    }
    static func getTracks(completion: @escaping (Result<[Track], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/tracks")
    
                      
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
    
        let url = URL(string: "\(baseURL)/track?isRandom=true")
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

    static func getSearchResult(query: String, completion: @escaping (Result<LibItem, NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/search?q=\(query)")
        
        print(url)
        URLSession.shared.dataTask(with: url!){ data, response, error in
            if error != nil {
                completion(.failure(.servererr))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print(response)
                return
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else{
                completion(.failure(.servererr))
                return
            }
            
        }.resume()
    }
    static func getSearchHistory(completion: @escaping (Result<[LibItem], NetworkError>) -> Void) {
        
        let url = URL(string: "\(baseURL)/search/history")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else{
                return
            }
            
            guard let mimeType = urlResponse.mimeType, mimeType == "application/json" else{
                return
            }
            
            do{
                let decoder = JSONDecoder()
                
                do{
                    let data =  try decoder.decode([LibItem].self, from: data!)
                    
                    completion(.success(data))
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
    
}
