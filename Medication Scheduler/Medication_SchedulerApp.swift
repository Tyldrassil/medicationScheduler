//
//  Medication_SchedulerApp.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI
import SwiftData

@main
struct Medication_SchedulerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    Medication.self,
                    Schedule.self
                ])
        }
    }
}
