//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/29/24.
//

import SwiftUI
import PhotosUI

struct UserProfile: View {
    
    @EnvironmentObject var profileModel: ProfileModel
    
    @State var picEditSheet = false
    
    var body: some View {
        VStack {
            Text("Personal information")
                .font(.subTitle)
                .foregroundColor(.primary1)
            
            EditableCircularProfileImage(viewModel: profileModel)
            
            Group {
                TextField("First Name", text: $profileModel.firstName)
                TextField("Last Name", text: $profileModel.lastName)
                TextField("Email", text: $profileModel.email)
                    .keyboardType(.emailAddress)
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)

            Spacer()
            Button("Logout") {
                
                profileModel.clear()

            }
            .buttonStyle(.bordered)

        }.padding()
    }
}

#Preview {
    UserProfile()
}
