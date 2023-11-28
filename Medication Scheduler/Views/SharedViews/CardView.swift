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
        RoundedRectangle(
            cornerRadius: 25
        )
        .fill(.white)
        .stroke(.black)
        .overlay {
            VStack {
                Text(page.name)
                Spacer() //Maybe add an image in between here aswell?
                Text(page.desc )
            }
            .padding(.vertical, 40)
        }
    }
}

#Preview("CardView Preview", traits: .fixedLayout(width: 400, height: 600)) {
    
    CardView(page: Page(id: 0, name: "test name", desc: "test desc"))
}

