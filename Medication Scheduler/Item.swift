//
//  Item.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
