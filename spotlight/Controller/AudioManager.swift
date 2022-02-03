//
//  AudioManager.swift
//  spotlight
//
//  Created by Bajo on 2021-11-03.
//

import Foundation
import AVFoundation
//import XCTest

var player: AVAudioPlayer!

enum PlayerControls{
    case pause
    case play
    case next
    case previous
    case resume
}

class AudioManager {
   
 // track queue arrays
    static var audioQueue = [Track]()
    static var previousTracks = [Track]()
    static var currentQueue: Track?
    
    static var timer: Timer!
    
    // current index of track in queue
    
    // initialize player with track queue or track
    static func initPlayer( track: Track?, tracks: [Track]?){
        
        print("init player")
        guard tracks != nil else {
            
            audioQueue = []
            currentQueue = track
            
            print("current track: ", currentQueue)
            
            playerController(option: .play)

            return
        }
        
        print(tracks)
        audioQueue = []
        audioQueue = tracks!.reversed()
        currentQueue = audioQueue.popLast()
        print("current Track: ", currentQueue)
        
        playerController(option: .play)
        
    }
    
    static func getTrack( track: Track){

        NetworkManager.getAudioTrack(track: track.audioURL!) { result in
            
            switch(result){
            case .success(let data ):
                print("requested track from network")
            
                initPlayerData(data: data)
                
            case .failure(let err):
                print( err)
            }
        }
        
    }
    
    // get track data
    static func initPlayerData( data: Data){
        do{
            player = try AVAudioPlayer(data: data)
            player!.play()
            
            print("initialize player")
            NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : currentQueue])
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
        }
        catch{
            print("Failed to play track")
            print(error)
        }
    }
    
    static func playerController(option: PlayerControls){
        
        switch(option){
        case .play:
           
            NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : currentQueue])
            
            if currentQueue != nil {
                getTrack(track: currentQueue!)    
                return
            }
            
            NetworkManager.getRandomAudioTrack( completion: { result in
                switch( result){
                case .success( let data):
                    print(data)
                    self.currentQueue = data
                    
                case .failure( let err):
                    print(err)
                }
            })
            
        case .pause:
            player!.pause()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
            
            guard timer != nil else {
                invalidateTimer()
                return
            }
            
        case .resume:
            player!.play()
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
            
        case .next:
            
            invalidateTimer()
            
            previousTracks.insert(currentQueue!, at: 0)
            currentQueue = audioQueue.popLast()
            print(audioQueue.count)
            
            
           if audioQueue.count < 1 {
                NetworkManager.getRandomAudioTrack( completion: { result in
                    switch( result){
                    case .success( let data):
//                        print(data)
                        self.audioQueue.append(data)
                        print(audioQueue)
                        
                        getTrack(track: currentQueue!)
                        

                    case .failure( let err):
                        print(err)
                    }
                })
           }else{
               getTrack(track: currentQueue!)

           }
           
        case .previous:
            
            guard timer != nil else {
                invalidateTimer()
//                print("Time is valid ")
//                print(timer.isValid)
                
                if(previousTracks.count == 0){
                    return
                }
                
                currentQueue! = previousTracks[0]
                previousTracks.remove(at: 0)
                
                getTrack(track: currentQueue!)
                
                return
            }
        }
    }
    static func getAudioQueue() -> [Track]{
        return audioQueue
    }
    
    static func getCurrentTrack() -> Track{
        guard currentQueue != nil else{
            print( "queue is empty")
            return Track(id: "", title: "Title", artistId: "", name: "Artist", imageURL: "", albumId: "", audioURL: "")
        }
        
        print("queue is not empty")
        return currentQueue!
        
    }
    
    @objc static func checkTrackIsEnded(){
         let formater = DateComponentsFormatter()
//        print("time: ", player.duration)
//        print("remainder: ", 1000 % Int(player!.duration)  )
//        print("Duration: ", formater.string(from: player!.duration)!)
//        print("CurrentDuration:", formater.string(from: player!.currentTime)!)
//        print("\n")
        
        if(Int(player!.currentTime) >= Int(player!.duration - 1)){
            
            
            playerController(option: .next)
            timer = nil
            
            print("track Ended")
            
            //TODO: // add track to play history
        }
    
    }
    
    static func setTimer(time: Timer){
        timer = time
    }
    
    static func invalidateTimer(){
        guard timer != nil else {
            return
        }
        timer.invalidate()
    }
}




