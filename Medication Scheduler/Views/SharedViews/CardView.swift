//
//  CardView.swift
//  Medication Scheduler
//
//  Created by Thomas Ditman on 16/10/2023.
//

import SwiftUI

struct CardView: View {
    
    let page: Page
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(page.name)
                .font(.headline)
                .padding(.top, 20)
            
            Spacer()
            Text(page.desc)
                .padding(.bottom, 20)
        }
        .padding(.all, 20)
    }
}

#Preview("CardView Preview", traits: .fixedLayout(width: 400, height: 60)) {
    
    CardView(page: Page(id: 0, name: "test name", desc: "test desc"))
}

