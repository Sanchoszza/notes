//
//  EditUserInfoViewModel.swift
//  fireStudy
//
//  Created by Alexandra on 12.08.2024.
//

import Foundation

@MainActor
final class EditUserInfoViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var birthday: Date = Date()
    @Published var userSurname: String = ""
    @Published var currentUserInfo: DBUser? = nil
    
    func loadUserInfo() {
        Task {
            do {
                let authDataResult = try AuthManager.shared.getAuthUser()
                let currentUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
                self.currentUserInfo = currentUser
                
                if let userInfo = currentUser.userInfo {
                    self.userName = userInfo.name ?? ""
                    self.birthday = userInfo.birthday ?? Date()
                    self.userSurname = userInfo.surname ?? ""
                }
            } catch {
                print("Faild to load userm info \(error)")
            }
        }
    }
    
    func addUserInfo() {
        Task {
            do {
                let authDataResult = try AuthManager.shared.getAuthUser()
                
                let currentUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
                self.currentUserInfo = currentUser

                let userInfo = UserInfo(
                                    id: "",
                                    name: userName,
                                    birthday: birthday,
                                    surname: userSurname)
//                                    user: currentUserInfo)
                
//                try await UserInfoManager.shared.addUserInfo(info: userInfo)
                try await UserManager.shared.updateUserCollection(userId: authDataResult.uid, userInfo: userInfo)

                userName = ""
                birthday = Date()
                userSurname = ""
                
            } catch {
                print("Failed to add note: \(error)")
            }
        }
    }
}
