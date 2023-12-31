//
//  NavigationList.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI

struct NavigationListView: View {
    
    var pages = [
        Page(
            id: 0,
            name: "Medications",
            desc: "This is a rather long descriptions for medications, intended to test the limit and use of the Spacer() in the grid"),
        Page(
            id: 1,
            name: "Schedule",
            desc: "This is a rather long descriptions for Schedule, intended to test the limit and use of the Spacer() in the grid")
    ]
    
    //Main view should display boxes that act as navigation to the rest of the app
    var body: some View {
        NavigationStack {
            Grid(alignment: .leadingFirstTextBaseline){
                //Leads to medications page
                GridRow {
                    NavigationLink(
                        destination: MedicationView(),
                        label: {
                            CardView(page: pages[0])
                        }
                    )
                }
                .padding(.all, 40)
                //Leads to Schedule
                GridRow {
                    NavigationLink(
                        destination: ScheduleView(),
                        label: {
                            CardView(page: pages[1])
                        }
                    )
                }
                .padding(.all, 40)
            }
        }
        
    }
}

#Preview {
    NavigationListView()
}
