//
//  IndividualMedicationView.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 17/10/2023.
//

import SwiftUI

struct IndividualMedicationView: View {
    
    var medication: Medication
    
    var body: some View {
        
        Text(medication.name)
    }
}

//#Preview {
//    IndividualMedicationView(medication: Medication(name: "Demo Med Name", measurement: "Demo med measurement"))
//}
