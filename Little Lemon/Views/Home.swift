//
//  Home.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var profileModel: ProfileModel
    @EnvironmentObject var nav: NavigationStateManager
    
    var body: some View {
        
        NavigationStack(path: $nav.path) {
            Menu()
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Image("Logo")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(value: NavDestination.profile) {
                            CircularProfileImage(imageState: profileModel.imageState, padding: 10)
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: NavDestination.order) {
                            Image(systemName: "cart.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .mask(Circle())
                                .padding()
                            
                        }
                    }
                    
                    
                })
                .navigationDestination(for: NavDestination.self) { dest in
                    
                    switch dest {
                    case .profile:
                        UserProfile()
                    case .order:
                        OrderView()
                    case .dishDetail(let dish):
                        DishDetail(dish: dish)
                    }
                    
                }
        }

        
        
    }
}

#Preview {
    Home()
}
