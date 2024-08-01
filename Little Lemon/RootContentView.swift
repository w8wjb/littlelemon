//
//  ContentView.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

struct RootContentView: View {
    
    @StateObject var nav = NavigationStateManager()
    
    var body: some View {
       Home()
            .environmentObject(nav)
    }
}

#Preview {
    RootContentView()
}
