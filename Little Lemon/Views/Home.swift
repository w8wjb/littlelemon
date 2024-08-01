//
//  Home.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

struct Home: View {
        
    @EnvironmentObject var profileModel: ProfileModel
    
    var body: some View {
        
        NavigationView {
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
                    NavigationLink(destination: UserProfile()) {
                        CircularProfileImage(imageState: profileModel.imageState, padding: 10)
                            .frame(width: 40, height: 40)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: Cart()) {
                        Image(systemName: "cart.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .mask(Circle())
                            .padding()
                            
                    }
                }
                
                
            })
        }
        

    }
}

#Preview {
    Home()
}
