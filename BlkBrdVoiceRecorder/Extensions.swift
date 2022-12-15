//
//  Extensions.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/15/22.
//

import Foundation


extension Date{
    
    func toString(dateFormat format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
