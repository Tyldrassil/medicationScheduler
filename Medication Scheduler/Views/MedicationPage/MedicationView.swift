//
//  MedicationView.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI
import SwiftData

struct MedicationView: View {
    
    @Query var medications: [Medication]
    @Environment(\.modelContext) private var modelContext
    
    //Main body of view
    var body: some View {
        NavigationSplitView {
            ZStack(alignment: .bottomTrailing) {
                
                //List of medications
                List {
                    
                    //ForEach used to access onDelete function
                    ForEach(medications) { medication in
                        IndividualMedicationView(medication: medication)
                        
                        //deletes appropriate medication
                    }.onDelete(perform: removeMedication)
                }
                //Floating action button
                Button {
                    addMedicationPlaceholder()
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4, x: 0, y: 4)
                }
                .padding()
            }
            
        } detail: {
            MedicationDetailView()
        }
    }
    
    /**
     Placeholder function for adding medications without wizard
     */
    private func addMedicationPlaceholder() {
        
        let newMedication = Medication(name: "Medication Name", measurement: "100 mg")
        
        modelContext.insert(newMedication)
        
    }
    
    /**
     Function deletes medication, used when dragging to the left on a list
     */
    private func removeMedication(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(medications[index])
        }
        
    }
}

#Preview {
    MedicationView()
}
