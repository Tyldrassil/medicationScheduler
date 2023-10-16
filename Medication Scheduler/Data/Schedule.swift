//
//  Schedule.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import Foundation
import SwiftData


/**
 Data to store times of day that medication is taken, and what medication is to be taken during that time
 
 - parameter id: unique id for time of day
 - parameter time: time of day for these medicines
 - parameter medications: list of medications to be taken at this time
 */

@Model
class Locations {
    
    @Attribute(.unique) var id: UUID = UUID()
    
    var time: Int
    var medications: [Medication]
    
    init(
        time: Int,
        medications: [Medication]
    ) {
        self.time = time
        self.medications = medications
    }
    
}
