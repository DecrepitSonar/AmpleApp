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
    case success
    case notfound
    case servererr
}

enum AuthenticationStatus: Error{
    case authenticationError
    case serverError
}

class NetworkManager {
    
    static let baseURL = "https://spotlight-ap.herokuapp.com/api/v1"
//    static let baseURL = "http://localhost:8080/api/v1"
//    static let baseURL = "https://app-server-savi4.ondigitalocean.app/"
    
    static let CDN = "https://prophile.nyc3.digitaloceanspaces.com/";
    
    static func Get<T: Decodable>(url: String, completion: @escaping (T?, NetworkError) -> ()){
        let url = URL(string: "\(baseURL)/\(url)")
        print(url!)
        URLSession.shared.dataTask(with: url!){ data, response, error in
            
            if error != nil {
//                    completion(.failure(.servererr))
//                    print(error)
            }
            
            guard let httpresponse = response as? HTTPURLResponse else {
                return
            }
            
            print(httpresponse)
            
            switch(httpresponse.statusCode){
        
                case 404:
//                    print(httpresponse)/
                    completion(nil, .notfound)
                
                break;
                
                case 500:
                    print("internal error")
                
                
                break;
                default:
                    print("reponse ok")
                
                    guard let mimeType = httpresponse.mimeType, mimeType == "application/json" else {
            
                        completion(nil, .success)
                        
                        return
                    }
                    
                    let decoder = JSONDecoder()
                
                    do {
                        let dataResponse = try decoder.decode(T.self, from: data!)
                        completion(dataResponse, .success)
                    }
                    catch{
                        print(error)
                    }
            }
                
                
        }.resume()
        
    }
    static func Post<T: Decodable, D: Encodable>(url: String, data: D, completion: @escaping (T?, NetworkError) -> ()){
        
        let _url = URL(string: "\(baseURL)/\(url)")
        print(baseURL)
        print(_url)
        var request = URLRequest(url: _url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("could not encode user credentials for authentication request")
            return
        }
        
        request.httpBody = encoded

        let task = URLSession.shared.uploadTask(with: request, from: encoded) { data, response, error in
            
            if error != nil {
                    print( error)
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            print(response)
            
            switch(response.statusCode){
                case 200:
                    
                    print("reponse ok")
                        
                    guard let mimeType = response.mimeType, mimeType == "application/json" else {
                        completion(nil, .success)
                        return
                    }
                
                    do {
                        let resp = try JSONDecoder().decode(T.self, from: data!)
                        completion(resp, .success)
                    }
                    catch{
                        print( error)
                    }

                case 500:
                completion(nil, .servererr)

                case 404:
                    completion(nil, .notfound)
                
                default:
                    print("Requst completed successfully")
            }

        }.resume()
        
    }
    static func Delete(url: String, completion: @escaping (NetworkError) -> ()){
        
        let url = URL(string: "\(baseURL)/\(url)")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        print(url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }

//            print(response.statusCode)

            switch(response.statusCode){
            case 200:
                completion(.success)

            case 500:
                print("Internal server error")
                completion(.servererr)

            case 404:
                print("could not complete request. item not found")
                completion(.notfound)

            default:
                print(response)
                print("Requst completed successfully")
            }

        }.resume()
        
    }
    static func Put<T: Codable>(url: String, data: T, completion: @escaping (T, NetworkError) -> ()){
        
        let url = URL(string: "\(baseURL)/\(url)")
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "Put"
        
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("could not encode user credentials for authentication request")
            return
        }
        
        request.httpBody = encoded

        let task = URLSession.shared.uploadTask(with: request, from: encoded) { data, response, error in
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
                    let data = try JSONDecoder().decode(T.self, from: data!)
                    completion(data, .success)
                }
                catch{
                    return
                }

            case 500:
                print("")

            case 403:
//                completion(.failure(.authenticationError))
                print("")
            default:
                print("Requst completed successfully")
            }
//
           

        }.resume()
        
    }
    static func loadLibraryContent(id: String, completion: @escaping (Result<[LibObject], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/library?user=\(id)")

        URLSession.shared.dataTask(with: url!){ data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.servererr))
                    print(error)
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

                print(dataResponse)
                completion(.success(dataResponse!))
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
//                    print(response)
                    return
                }
                print( httpresponse)
                guard let mimeType = httpresponse.mimeType, mimeType == "image/jpeg" else {
                    completion(.failure(.ServerError))
                    print("mime err")
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
    static func getSearchResult(query: String, completion: @escaping (Result<[LibItem], NetworkError>) -> Void){
        let url = URL(string: "\(baseURL)/search?q=\(query)")
        
        print(url)
//        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: url!){ data, response, error in
                if error != nil {
                    completion(.failure(.servererr))
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
    //                print(response)
                    return
                }
                
                guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else{
                    completion(.failure(.servererr))
                    return
                }
                
                do{
                    let deconder = JSONDecoder()
                    
                    let result = try deconder.decode([LibItem].self, from: data!)
//                    print(result)
                    completion(.success(result))
                }
                catch{ print( error)}
                
            }.resume()
//        }
        
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
