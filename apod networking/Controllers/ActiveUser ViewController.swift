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
    
    @Published var filteredApods:[ApodEntity] = []
    @Published var favorites: [ApodEntity] = []
    
    @Published var apodCreatedSearch = ""
    
    private var  cancellables = Set<AnyCancellable>()
    
    let defaultImage = UIImage(systemName: "photo.on.rectangle")!
    
    var defaultImageData: Data {
    defaultImage.jpegData(compressionQuality: 0.5)!
     }
      
    @Published var reload:Bool = false
    @Published var chevronTitle:String = "chevron.up"
    
    init () {
        activeUserInfo()
        favoritesApod()
        self.addSubscriber()
    }
    
   

// this method was not later used but might still be included    hence, the commented implementation
    private func addSubscriber () {
        
      $apodCreatedSearch
            .combineLatest(allUsers.$allApods)
            .map { (searchedtext, apodentities) -> [ApodEntity] in
                guard !searchedtext.isEmpty else { return apodentities }
                
                let lowercasedtext = searchedtext.lowercased()
               return apodentities.filter { apod -> Bool in
                   apod.title?.lowercased().contains(lowercasedtext) ?? false
                }
            }
            .sink {[weak self] filteredapodentities in
                self?.filteredApods = filteredapodentities
            }
            .store(in: &cancellables)
    }
    
    
    
    func setUserIsActive (value:Bool) {
        userIsActive = value
    }
    
//    method to save/delete the userinfo to the user device using userdefaults
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
    
   
//    method to get the activeuserinfo from userdefaults
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
    
//    this method obtain the bollean value from the userisactive property
    func userActive () -> Bool {
        
        if userIsActive ?? false {
            return true
        }
        else {
           return false
        }
    }
    
}
    
   
