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
    
    static var timer: Timer!
    
    // current index of track in queue
    static var currentQueue: Int?
    
    // initialize player with track queue or track
    static func initPlayer( track: Track?, tracks: [Track]?){
        
        currentQueue = 0
        
        guard tracks != nil else {
            print("Track", track!)
            
            audioQueue = []
            audioQueue.append(track!)
            print("audioQueue", audioQueue)
            
            playerController(option: .play)
            return
        }
        
        audioQueue = []
        audioQueue = tracks!
        
        print("Tracks", tracks!)
        
        playerController(option: .play)
        
        // keep track of current playback state
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkTrackIsEnded), userInfo: nil, repeats: true)
        
        
    }
    
    static func getTrack( track: Track){

        NetworkManager.getAudioTrack( track: track.audioURL!) { result in
            
            switch(result){
            case .success(let data ):
            
                initPlayerData(data: data)
                
                NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : track])
                
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
            getTrack(track: audioQueue[self.currentQueue!])
                                    
//            print(audioQueue[currentQueue!])
            
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
            
            currentQueue! += 1
            if(currentQueue! >= audioQueue.count){
                

                NetworkManager.getRandomAudioTrack( completion: { result in
                    switch( result){
                    case .success( let data):
                        print(data)
                        self.audioQueue.append(data)
                        getTrack(track: audioQueue[self.currentQueue!])
                        
                        
                    case .failure( let err):
                        print(err)
                    }
                })
                
            }else{
                getTrack(track: audioQueue[currentQueue!])
                
                NotificationCenter.default.post(name: Notification.Name("update"), object: nil, userInfo: ["track" : audioQueue[currentQueue!]])
            }
            
        case .previous:
            
            guard timer != nil else {
                invalidateTimer()
                print("Time is valid ")
                print(timer.isValid)
                
                if(currentQueue == 0){
                    return
                }
                
                currentQueue! -= 1
                getTrack(track: audioQueue[currentQueue!])
                
                return
            }
        }
    }
    static func getAudioQueue() -> [Track]{
        return audioQueue
    }
    
    static func getCurrentTrack() -> Track{
        guard audioQueue.isEmpty else{
            print( "queue is empty")
            return audioQueue[currentQueue!]
        }
        
        print("queue is not empty")
        return Track(id: "", title: "Title", artistId: "", name: "Artist", imageURL: "", albumId: "", audioURL: "")
        
    }
    
    @objc static func checkTrackIsEnded() -> Bool{
         let formater = DateComponentsFormatter()
        print("time: ", player.duration)
        print("remainder: ", 1000 % Int(player!.duration)  )
        print("Duration: ", formater.string(from: player!.duration)!)
        print("CurrentDuration:", formater.string(from: player!.currentTime)!)
        print("\n")
        
        if(Int(player!.currentTime - 1) == Int(player!.duration)){
            
            
            playerController(option: .next)
            timer = nil
            
            print("track Ended")
            
            return true
            //TODO: // add track to play history
        }
    
        return false
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




