//
//  Header.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/30/24.
//

import SwiftUI

struct Header: View {
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("Logo")
                .frame(maxWidth: .infinity, alignment: .center)
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .mask(Circle())
                .padding([.trailing])

        }
    }
}

#Preview {
    Header()
}
