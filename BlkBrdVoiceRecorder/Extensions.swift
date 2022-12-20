//
//  Extensions.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/15/22.
//

import Foundation
import AVFoundation


extension Date{
    
    func toString(dateFormat format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}


extension AVMutableCompositionTrack {
    func append(url: URL) {
        let newAsset = AVURLAsset(url: url)
        let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
        let end = timeRange.end
        print(end)
        if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
            try! insertTimeRange(range, of: track, at: end)
        }
        
    }
}

//Extension to check if headphones are connected to the device
extension AVAudioSession {

    static var isHeadphonesConnected: Bool {
        return sharedInstance().isHeadphonesConnected
    }

    var isHeadphonesConnected: Bool {
        return !currentRoute.outputs.filter { $0.isHeadphones }.isEmpty
    }

}
// support extension to the AVAudioSession
extension AVAudioSessionPortDescription {
    var isHeadphones: Bool {
        return portType == AVAudioSession.Port.headphones
    }
}
