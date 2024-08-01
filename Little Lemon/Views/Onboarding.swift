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
    @State var phone: String = ""
    
    @EnvironmentObject var profileModel: ProfileModel
    
    var isFormValid: Bool {
        return !firstName.isEmpty
        && !lastName.isEmpty
        && email.contains("@")
        && !phone.isEmpty
    }
    
    
    var body: some View {
        VStack {
            
            Hero()
            
            Form {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)

            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            Button("Register") {
                
                profileModel.firstName = firstName
                profileModel.lastName = lastName
                profileModel.email = email
                profileModel.phone = phone
                profileModel.onboarded = true
                
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isFormValid)
            
            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        
    }
}

#Preview {
    Onboarding()
}
