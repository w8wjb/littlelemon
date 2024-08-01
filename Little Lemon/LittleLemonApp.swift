//
//  LittleLemonApp.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    
    let persistence = PersistenceController.shared

    @StateObject var profileModel = ProfileModel()
    
    var body: some Scene {
        WindowGroup {            
            if profileModel.onboarded {
                RootContentView()
                    .task {
                        profileModel.loadProfileImage()
                    }
            } else {
                Onboarding()
            }
        }
        .environment(\.managedObjectContext, persistence.container.viewContext)
        .environmentObject(profileModel)
        
    }
}
