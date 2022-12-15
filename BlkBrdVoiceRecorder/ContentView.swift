//
//  ContentView.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/15/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationView {
            VStack {
                
                //MARK: Recordings List
                RecordingsList(audioRecorder: audioRecorder)
                
                //MARK: The record button if/else
                if audioRecorder.recording == false{
                    Button {
                        print("Start recording")
                        self.audioRecorder.startRecording()
                    } label: {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                    
                } else{
                    
                    Button {
                        print("Stop Recording")
                        self.audioRecorder.stopRecording()
                    } label: {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                    
                    
                }
            }
            .navigationTitle("Voice Recorder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder())
    }
}
