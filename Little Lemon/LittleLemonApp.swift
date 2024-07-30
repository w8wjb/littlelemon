//
//  LittleLemonApp.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    
    @AppStorage(kCustomerOnboarded) private var customerOnboarded: Bool = false;
    
    var body: some Scene {
        WindowGroup {            
            if customerOnboarded {
                RootContentView()
            } else {
                Onboarding()
            }
        }
    }
}
