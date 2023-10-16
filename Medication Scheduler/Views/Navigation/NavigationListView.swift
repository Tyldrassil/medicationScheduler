//
//  NavigationList.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI

struct NavigationListView: View {
    
    var pages = [Page(id: 0, name: "Item 1",desc: "desc 1"), Page(id: 1, name: "Item 2",desc: "desc 2")]
    
    var body: some View {
        NavigationSplitView {
            List(pages) {page in
                NavigationLink {
                    ScheduleView()
                } label: {
                    PageRow(page: page)
                }
            }
        } detail: {
            Text("Navigate to a page")
        }
        Text("TODO")
    }
}

#Preview {
    NavigationListView()
}
