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

class AudioManager {
   
 // track queue arrays
    
    var audioQueue = [Track]()
    var previousTracks = [Track]()
    var currentQueue: Track?
    var player: AVAudioPlayer!
    var progressBar: UISlider!
    var timer: Timer!
    
    static let shared = AudioManager()
    
    // current index of track in queue
    
    // initialize player with track queue or track
    func initPlayer( track: Track?, tracks: [Track]?){
        
        print("init player")
        guard tracks != nil else {
            
            if audioQueue.count < 1 {
            
                NetworkManager.getRandomAudioTrack( completion: { result in
                    switch( result){
                    case .success( let data):
                        print(data)
                        self.audioQueue.append(data)
                        
                    case .failure( let err):
                        print(err)
                    }
                })
                
            }
            
            currentQueue = track
            
            print("current track: ", currentQueue)
            
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

        NetworkManager.getAudioTrack(track: track.audioURL!) { result in
            
            switch(result){
            case .success(let data ):
                print("requested track from network")
            
                
                do{
                    self.player = try AVAudioPlayer(data: data)
                    if( self.player.prepareToPlay()) {
                        self.player.play()
                        
                        NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : self.currentQueue])
                        NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
                    }
                    
                    print("initialize player")
                }
                catch{
                    print("Failed to play track")
                    print(error)
                }

                
            case .failure(let err):
                print( err)
            }
        }
        
    }
    
    func playerController(option: PlayerControls){
        
        switch(option){
        case .play:
            
            if currentQueue != nil {
                getTrack(track: currentQueue!)    
                return
            }
            
            player.play()
            
        case .pause:
            player!.pause()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
            
        case .resume:
            player!.play()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
            
        case .next:
            
            previousTracks.insert(currentQueue!, at: 0)
            print("current Queue: ", audioQueue)
            
            currentQueue = audioQueue.removeFirst()
//
            getTrack(track: currentQueue!)
            
            if audioQueue.isEmpty {
                NetworkManager.Get(url: "track?isRandom=true") { ( data: Track?, error: NetworkError) in
                    switch( error){
                    case .success:

                        self.audioQueue.append(data!)

                    case .notfound:
                        print("url not found")
                        
                    case .servererr:
                        print( "internal server error")
                    }
                }
            }
            
           
        case .previous:
            
//            guard timer != nil else {
//                invalidateTimer()
//                print("Time is valid ")
//                print(timer.isValid)
                
                if(previousTracks.count == 0){
                    return
                }
                
                currentQueue! = previousTracks[0]
                previousTracks.remove(at: 0)
                
                getTrack(track: currentQueue!)
                
//                return
//            }
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
    
    @objc func checkTrackIsEnded(timer: Timer) -> Bool{
        
        if(Int(player!.currentTime) >= Int(player!.duration - 1)){
            timer.invalidate()
            playerController(option: .next)
            
            
            print("track Ended")
            
            //TODO: // add track to play history
            
            return true
        }
        
        return false
    }
}




