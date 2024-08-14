//
//  EditUserInfoView.swift
//  fireStudy
//
//  Created by Alexandra on 12.08.2024.
//

import SwiftUI

struct EditUserInfoView: View {
    
    @StateObject private var viewModel = EditUserInfoViewModel()
    
    var body: some View {
        
        VStack {
            TextField(NSLocalizedString("enterName", comment: ""), text: $viewModel.userName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            DatePicker(
                NSLocalizedString(NSLocalizedString("selectDate", comment: ""), comment: ""),
                selection: $viewModel.birthday,
                displayedComponents: .date
            )
            .datePickerStyle(WheelDatePickerStyle())
            
            TextField(NSLocalizedString("enterSurname", comment: ""), text: $viewModel.userSurname)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button {
                viewModel.addUserInfo()
            } label: {
                Text(NSLocalizedString("save", comment: ""))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .navigationTitle(NSLocalizedString("editInfo", comment: ""))
        .padding()
        .onAppear {
            viewModel.loadUserInfo()
        }
    }
}

//#Preview {
//    EditUserInfoView(showEditProfileView: .constant(false))
//}
