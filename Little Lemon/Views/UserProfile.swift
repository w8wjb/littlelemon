//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

struct UserProfile: View {
    
    @AppStorage(kCustomerFirstName) var customerFirstName: String = ""
    @AppStorage(kCustomerLastName) var customerLastName: String = ""
    @AppStorage(kCustomerEmail) var customerEmail: String = ""
    @AppStorage(kCustomerOnboarded) var customerOnboarded: Bool = false;
    
    var body: some View {
        VStack {
            Text("Personal information")
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .mask(Circle())
            
            Group {
                TextField("First Name", text: $customerFirstName)
                TextField("Last Name", text: $customerLastName)
                TextField("Email", text: $customerEmail)
                    .keyboardType(.emailAddress)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)

            Spacer()
            Button("Logout") {
                
                customerFirstName = ""
                customerLastName = ""
                customerEmail = ""
                customerOnboarded = false
                
            }
            .buttonStyle(.bordered)

        }.padding()
    }
}

#Preview {
    UserProfile()
}
