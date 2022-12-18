//
//  ConcatenateAudioFiles.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/15/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class ConcatenateAudioFiles {
    
    var mergeAudioURL = NSURL()

    
    func createArray(audioRecorder:AudioRecorder) async throws -> URL{
        var soundArray = [URL]()
        
        for recording in audioRecorder.recordings{
            soundArray.append(recording.fileURL)
        }

       //mergeAudioFiles(audioFileUrls: soundArray)
        let outputURL = try await concatenateAudioFiles(urls: soundArray)
        
        //return mergeAudioURL as URL
        return outputURL
    }
    

    func mergeAudioFiles(audioFileUrls: Array<URL>) {
        let composition = AVMutableComposition()

        for i in 0 ..< audioFileUrls.count {

            let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!

            let asset = AVURLAsset(url: (audioFileUrls[i] ) as URL)

            let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
            

            let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: track.timeRange.duration)


            try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
        }

        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL

        //Test
        if documentDirectoryURL.appendingPathComponent("FinalAudio.m4a")!.hasDirectoryPath {
            do {
                try FileManager.default.removeItem(at: documentDirectoryURL.appendingPathComponent("FinalAudio.m4a")!)
                print("File was successfully removed")
            } catch {
                print("Error removing file: \(error)")
            }
        }
        
        self.mergeAudioURL = documentDirectoryURL.appendingPathComponent("FinalAudio.m4a")! as URL as NSURL

        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = mergeAudioURL as URL
        assetExport?.exportAsynchronously(completionHandler:
            {
                switch assetExport!.status
                {
                case AVAssetExportSession.Status.failed:
                    print("failed \(String(describing: assetExport?.error))")
                case AVAssetExportSession.Status.cancelled:
                    print("cancelled \(String(describing: assetExport?.error))")
                case AVAssetExportSession.Status.unknown:
                    print("unknown\(String(describing: assetExport?.error))")
                case AVAssetExportSession.Status.waiting:
                    print("waiting\(String(describing: assetExport?.error))")
                case AVAssetExportSession.Status.exporting:
                    print("exporting\(String(describing: assetExport?.error))")
                default:
                    print("Audio Concatenation Complete")
                }
        })
    }
    
    
    
    func concatenateAudioFiles(urls: [URL]) async throws -> URL {
        let composition = AVMutableComposition()
        
        let checkURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("concatenated.m4a")
        
        deleteFinalRecording(urlToDelete: checkURL)

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
    
    
    func deleteFinalRecording(urlToDelete: URL){
        
            print("DEBUG:deleteRecording - URL attempting to delete \(urlToDelete)")
            
            do{
                try FileManager.default.removeItem(at: urlToDelete)
                print("DEBUG:deleteRecording - Sucessfully deleted \(urlToDelete)")
            } catch{
                print("DEBUG:deleteRecording - File could not be deleted!")
            }
            
        
    }

}
