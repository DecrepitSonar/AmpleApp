//
//  AudioManager.swift
//  spotlight
//
//  Created by Bajo on 2021-11-03.
//

import Foundation
import AVFoundation

var player: AVAudioPlayer?

class AudioManager{

//    var player: AVAudioPlayer?
    
    static func getTrack( track: String){
        
//        let path = Bundle.main.path(forResource: "6LACK - Nonchalant (Official Music Video).mp3", ofType: nil)
//        let url = URL(fileURLWithPath: path!)
        print(track)
        NetworkManager.getAudioTrack( track: track) { result in
            
            switch(result){
            case .success(let resData ):
                playTrack(with: resData)
            case .failure(let err):
                print( err)
            }
        }
        
    }
    
    static func playTrack( with data: Data?){
        
        do{
            player = try AVAudioPlayer(data: data!)
            player!.play()
            print(player!.isPlaying)
            NotificationCenter.default.post(name: NSNotification.Name("isPlaying"), object: nil)
        }
        catch{
            print("Failed to play track")
            print(error)
        }
        
    }
    
    
}




