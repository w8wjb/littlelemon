//
//  Hero.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/31/24.
//

import SwiftUI

struct Hero: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Little Lemon")
                .font(.displayTitle)
                .foregroundColor(.primary2)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Grand Rapids")
                        .font(.subTitle)
                        .foregroundColor(.white)

                    
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.leadText)
                        .foregroundColor(.white)
                }
                
                Image("Hero image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding()
            }

                
        }
        .frame(maxWidth: .infinity)
        .padding(.trailing, 0)
        .padding([.leading])
        .background(Color.primary1)
    }
}

#Preview {
    Hero()
}
