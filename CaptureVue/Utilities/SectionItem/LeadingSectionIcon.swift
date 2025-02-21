//
//  LeadingSectionIcon.swift
//  CaptureVue
//
//  Created by Paris Makris on 21/2/25.
//

import SwiftUI

struct LeadingSectionIcon: View {
    let systemName: String
    
    init(_ systemName: String) {
        self.systemName = systemName
    }
    
    var body: some View {
        Image(systemName: systemName)
            .font(Typography.medium(size: 16))
            .foregroundStyle(Color.black.opacity(0.8))
        
    }
}

#Preview {
    LeadingSectionIcon("person.3.fill")
}
