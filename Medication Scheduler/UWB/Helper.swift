//
//  Helper.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 29/11/2023.
//

import Foundation

enum Helper {
    
    /// A key that is used for transferring discovery tokens between devices.
    static let discoveryTokenKey: String = "discovery-token"
    
    /// A formatter that converts a distance to a string with units.
    static var localFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.alwaysShowsDecimalSeparator = false
        formatter.numberFormatter.roundingMode = .ceiling
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.numberFormatter.minimumFractionDigits = 0
        return formatter
    }()
    
    /// The unit length for the device's current locale.
    static var localUnits: UnitLength {
        Locale.current.usesMetricSystem ? .meters : .feet
    }
}