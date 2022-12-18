//
//  ConcatenateAudioFilesTwo.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/16/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class ConcatenateAudioFilesTwo {
    
    
    func concatenateAudioFiles(urls: [URL]) async throws -> URL {
        let composition = AVMutableComposition()

        // Add audio tracks from each URL to the composition
        for url in urls {
            let asset = AVURLAsset(url: url)
            for track in asset.tracks(withMediaType: .audio) {
                let compositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                try compositionTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: track, at: composition.duration)
            }
        }

        // Export the composition to a new audio file
        let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("concatenated.m4a")
        exportSession?.outputURL = tempURL
        exportSession?.outputFileType = .m4a
        try await exportSession?.export()

        return tempURL
    }
}


//To use this function, you can pass it an array of audio file URLs like this:

//let audioURLs = [
//    URL(string: "https://example.com/audio1.m4a")!,
//    URL(string: "https://example.com/audio2.m4a")!,
//    URL(string: "https://example.com/audio3.m4a")!
//]
//
//let outputURL = try concatenateAudioFiles(urls: audioURLs)
