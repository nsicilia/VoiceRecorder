//
//  CombinedAudioPlayerView.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/15/22.
//

import SwiftUI


struct CombinedAudioPlayerView: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    @ObservedObject var audioRecorder: AudioRecorder
    
    @Binding var combinedURL: URL?
    
    
    var body: some View{
        VStack{
           // Text("Int: \(testInt)")
            Text("Combined Audio")
            
            HStack(spacing: 20){
                
                Button {
                    print("play combined audio")
                } label: {
                    //MARK: Play/Pause Button
                    if audioPlayer.isPlaying == false {
                        //Audio is not playing
                        Button {
                            //let temp = try! ConcatenateAudioFiles().createArray(audioRecorder: audioRecorder)
                            if let combined = combinedURL{
                                self.audioPlayer.startPlayback(audio: combined)
                            }
                                
                           // self.audioPlayer.startPlayback(audio: temp)
                            print("Start playing audio")
                        } label: {
                            Image(systemName: "play.circle")
                                .imageScale(.large)
                        }
                        
                    }else{
                        //Audio is playing
                        Button {
                            print("Stop playing audio")
                            
                            //self.audioPlayer.stopPlayback()
                            self.audioPlayer.pausePlayback()
                            
                        } label: {
                            Image(systemName: "stop.fill")
                                .imageScale(.large)
                        }
                        
                    }
                }
                
            }
        }
        
    }
    

}



struct CombinedAudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedAudioPlayerView(/*audioURL: URL(string: "https://www.apple.com")!*/ audioRecorder: AudioRecorder(), combinedURL: .constant(URL(string: "https://www.apple.com")!))
    }
}
