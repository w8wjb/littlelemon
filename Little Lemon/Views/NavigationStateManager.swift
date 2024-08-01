//
//  NavigationStateManager.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

class NavigationStateManager: ObservableObject {

    @Published var path = [NavDestination]()
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = [NavDestination]()
    }
    
    func switchToOrder() {
        
        guard path.count > 0 else { return }
        path.removeLast()
        path.append(NavDestination.order)
        
    }

}
