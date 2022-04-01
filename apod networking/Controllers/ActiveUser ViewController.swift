//
//  ActiveUser ViewController.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import Foundation
import CoreData
import SwiftUI
import Combine


class ActiveUserController: ObservableObject {
    

    static let saveUserActive = "user is active"
    
    @AppStorage("active") private(set) var userIsActive:Bool?
    
    var activeUser: UsersEntity?
    var apodToCreate: ApodServer?
    
    let controller = UsersManager.shared
    let allUsers = UsersController.shared
    let dowloadApod = ApodDataService()
    
    @Published var allDownloadedApods:[ApodServer] = []
    @Published var favorites: [ApodEntity] = []
    
    private var  cancellables: AnyCancellable?
    
    let defaultImage = UIImage(systemName: "photo.on.rectangle")!
    
    var defaultImageData: Data {
    defaultImage.jpegData(compressionQuality: 0.5)!
     }
      
    @Published var reload:Bool = false
    @Published var chevronTitle:String = "chevron.up"
    
    init () {
        self.allDownloadedApods = []
        activeUserInfo()
        favoritesApod()
        self.addSubscriber()
    }
    
   

    
    private func addSubscriber () {
        
//    DispatchQueue.main.async {[weak self] in
//
//        self?.cancellables = self?.dowloadApod.$allApodContents
//                .receive(on: DispatchQueue.main)
//                .sink { [weak self]dowloadedApods in
//                    print("recieving")
//                    print("\(dowloadedApods)")
//                    self?.allDownloadedApods = dowloadedApods
//                }
//        }

            
    }
    
    
    
    func setUserIsActive (value:Bool) {
        userIsActive = value
    }
    
    func saveActiveUserInfo () {
        guard let activeUser = activeUser else {
            UserDefaults.standard.set(nil, forKey: Self.saveUserActive)
            return
        }

        if let encoded = try? JSONEncoder().encode(activeUser) {
            UserDefaults.standard.set(encoded, forKey: Self.saveUserActive)
            print("this is user is saved to memory")
        }
    }
    
   
    
    func activeUserInfo () {
        
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = controller.userViewContext
        
        guard let decoded = UserDefaults.standard.data(forKey: Self.saveUserActive) else {
            print("couldnt get the requested data from the user default")
            activeUser = nil
            return
        }
            
            do {
                let activeUserDecoded =  try decoder.decode(UsersEntity.self, from: decoded)
                
                    for user in allUsers.allUsers {
                        
                        if user.userName == activeUserDecoded.userName {
                            activeUser = user
                            return
                        }
                    }
            }
            catch let error {
                activeUser = nil
                print("error decoding the active user data: \(error)")
            }

    }
    
    func userActive () -> Bool {
        
        if userIsActive ?? false {
            return true
        }
        else {
           return false
        }
    }
    
}
    
   
