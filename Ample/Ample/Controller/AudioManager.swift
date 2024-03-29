//
//  AudioManager.swift
//  spotlight
//
//  Created by Bajo on 2021-11-03.
//

import Foundation
import AVFoundation
import UIKit
//import XCTest

enum PlayerControls{
    case pause
    case play
    case next
    case previous
    case resume
}

var audioQueue: [Track] = []

class AudioManager: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioManager()
   
    var audioQueue = [Track]()
    var previousTracks = [Track]()
    var currentQueue: Track?
    var player: AVAudioPlayer!
    var progressBar: UISlider!
    var timer: Timer!
    var isPlaying: Bool!
    var isSaved: Bool = false
    
    override init(){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
        
    }
    
    // initialize player with track queue or track
    func initPlayer( track: Track?, tracks: [Track]?){
        
        print( tracks )
        print("init player")
        
        guard tracks != nil else {
            print(audioQueue.count )
            
            currentQueue = track
            
            print("current track: ", currentQueue)
            
            if audioQueue.isEmpty {
                getTrackForQueue()
            }
            
            playerController(option: .play)

            return
        }

        audioQueue = []
        audioQueue = tracks!
        currentQueue = audioQueue.removeFirst()
        print("current Track: ", currentQueue)
        
        playerController(option: .play)
        
    }
    func getTrack( track: Track){

        // Retrieve net current track from network
        NetworkManager.getAudioTrack(track: track.audioURL!) { result in
            
            switch(result){
            case .success(let data ):
                
                print("requested track from network")
                
                do{
                    self.player = try AVAudioPlayer(data: data)
                    self.player.delegate = self
                    
                    print("playing retrieved track")
                    self.player.prepareToPlay()
                    self.player.play()
                    
//                    if self.audioQueue.isEmpty{
                        self.currentQueue = track
//                    }else{
//                        self.currentQueue = self.audioQueue.removeFirst()
//                    }
    
                    NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: nil)
                    NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
                    
                    print("initialize player")
                }
                catch{
                    print("Failed to play track")
                    self.playerController(option: .next)
                    print(error)
                }

            case .failure(let err):
                print("failed to set player")
                self.playerController(option: .next)
                print( err)
            }
        }
    
        
        // Check if track is saved by user
//        let user = UserDefaults.standard.object(forKey: "userdata")
//        NetworkManager.Get(url: "user/savedTracks?id=\(track.id)&&user=\(user!)") {(data: Bool?, error: NetworkError) in
//
//            switch(error){
//            case .success:
//                self.isSaved = true
//
//            default:
//                self.isSaved = false
//                return
//            }
//
//        }
        
    }
    func getTrackForQueue() {
        NetworkManager.Get(url: "track?isRandom=true") { ( track: Track?, error: NetworkError) in
            switch( error){
            case .success:
                self.audioQueue.append(track!)
                
            case .notfound:
                print("url not found")
                
            case .servererr:
                print( "internal server error")
            }
        }
    }
    
    func playerController(option: PlayerControls){
        
        switch(option){
        case .play:
            
            print("playing track")
            if currentQueue != nil {
                getTrack(track: currentQueue!)    
                return
            }
            
            guard audioQueue.isEmpty else {
                getTrackForQueue()
                return
            }
            
            print(audioQueue)
            
        case .pause:
            print("Track paused")
            player.pause()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
            
        case .resume:
            print("resuming track")
            player.play()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
            
        case .next:

            guard !audioQueue.isEmpty else {
                return
            }
             
            if( currentQueue != nil){
                self.previousTracks.insert(self.currentQueue!, at: 0)
                
                currentQueue = audioQueue.removeFirst()
                
                if( audioQueue.isEmpty) {
                    getTrackForQueue()
                }
                
            }
            
            getTrack(track: currentQueue!)
           
        case .previous:
            
            guard currentQueue != nil else {
                return
            }
            
            if player.currentTime > 0 {
                player.currentTime = 0.0
            }
            
                if(previousTracks.count == 0){
                    return
                }
                
                currentQueue! = previousTracks[0]
                previousTracks.remove(at: 0)
                
                getTrack(track: currentQueue!)
                
        }
    }
    func getAudioQueue() -> [Track]{
        return audioQueue
    }
    func getCurrentTrack() -> Track{
        
        guard currentQueue != nil else{
            print( "queue is empty")
            return Track(id: "", title: "Title", artistId: "", name: "Artist", imageURL: "", albumId: "", audioURL: "")
        }
        
        print("queue is not empty")
        return currentQueue!
        
    }
    
//    @objc func checkTrackIsEnded() -> Bool{
//
//        if(player.currentTime == player.duration){
//
//            timer.invalidate()
////            playerController(option: .next)
//
//            print("track Ended")
//
//            //TODO: // add track to play history
//
//            return true
//        }
//
//        return false
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if( flag ){
            print("AudioPlayer Finnished")
            AudioManager.shared.playerController(option: .next)
            
            // add track to listening history
//            NetworkManager.Post(url: <#T##String#>, data: <#T##Encodable#>, completion: <#T##(Decodable?, NetworkError) -> ()#>)
        }
    }
}




