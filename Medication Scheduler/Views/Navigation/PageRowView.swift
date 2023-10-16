//
//  PageRow.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI

struct PageRow: View {
    var page: Page
    
    var body: some View {
        VStack {
            Text(page.name)
            Text(page.desc)
        }
    }
}

#Preview {
    PageRow(page: Page(id: 0, name: "Test name", desc: "test desc"))
}
