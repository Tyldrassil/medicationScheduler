//
//  pages.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import Foundation



struct Page: Hashable, Codable, Identifiable {
    
    var id: Int
    var name: String
    var desc: String
}
