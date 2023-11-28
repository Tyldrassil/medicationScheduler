//
//  Medication.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import Foundation
import SwiftData

/**
 Datatype used for medication
 
 - parameter id: Unique ID
 - parameter name: name of medication
 - parameter measurement: measurement of medication, e.g: mg, oz, etc.
 */

@Model
class Medication {
    
    @Attribute(.unique) var id: UUID = UUID()
    
    var name: String
    var measurement: String
    
    init (
        name: String,
        measurement: String
        
    ) {
        self.id = UUID()
        self.name = name
        self.measurement = measurement
    }
    
}
