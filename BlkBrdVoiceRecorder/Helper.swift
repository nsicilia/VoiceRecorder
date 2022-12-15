//
//  Helper.swift
//  BlkBrdVoiceRecorder
//
//  Created by Nicholas Siciliano-Salazar  on 12/15/22.
//

import Foundation

func getCreationDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}
