//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI

struct Onboarding: View {
    
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    
    @AppStorage(kCustomerFirstName) var customerFirstName: String = ""
    @AppStorage(kCustomerLastName) var customerLastName: String = ""
    @AppStorage(kCustomerEmail) var customerEmail: String = ""
    @AppStorage(kCustomerOnboarded) var customerOnboarded: Bool = false;
    

    var isFormValid: Bool {
        return !firstName.isEmpty
        && !lastName.isEmpty
        && email.contains("@")
    }
    
    
    var body: some View {
        VStack {
            
            Group {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)


            
            Button("Register") {
                
                customerFirstName = firstName
                customerLastName = lastName
                customerEmail = email
                customerOnboarded = true
                
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
        }
        .padding()
    }
}

#Preview {
    Onboarding()
}
