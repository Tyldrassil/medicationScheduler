//
//  ContentView.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI
import NearbyInteraction

struct ContentView: View {
    
    var body: some View {
        NavigationListView()
    }
    
    /*@ObservedObject var niManager: NearbyInteractionManager
        
        #if os(watchOS)
        let connectionDirections = "Open the app on your phone to connect"
        #else
        let connectionDirections = "Open the app on your watch to connect"
        #endif
        
        var body: some View {
            VStack(spacing: 10) {
                if niManager.isConnected {
                    if let distance = niManager.distance?.converted(to: Helper.localUnits) {
                        Text(Helper.localFormatter.string(from: distance)).font(.title)
                    } else {
                        Text("-")
                    }
                } else {
                    Text(connectionDirections)
                }
            }
        }*/
}

//#Preview {
    //ContentView()
//}


