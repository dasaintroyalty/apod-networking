//
//  Users Model Controller.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class UsersManager {
    
    static let shared = UsersManager()
    
    let userPersistentContainer: NSPersistentContainer
    let userViewContext: NSManagedObjectContext
    
    init() {
        
      userPersistentContainer = NSPersistentContainer(name: "UsersModel")
      userPersistentContainer.loadPersistentStores{ (description, error) in
            if let error = error {
                print("error loading Core data: \(error)")
            }
        }
        
        userViewContext = userPersistentContainer.viewContext
        userViewContext.mergePolicy =  NSMergeByPropertyObjectTrumpMergePolicy
        
    }
    
    
    func save () {
        
     
            do {
                try userViewContext.save()
                print("saved")
            }
            catch let error {
                print("error saving CoreData: \(error.localizedDescription)")
            }
            
        
    }
    
    
    
}



class UsersController: ObservableObject {
    
    static let shared = UsersController()
    
    let manager = UsersManager.shared
    
    @Published var allUsers: [UsersEntity] = []
    @Published var allApods: [ApodEntity] = []
    
   
    init() {
        
        fetchUsers()
        fetchApods()
    }
    
    func fetchUsers () {
        
        let fetchQuery = NSFetchRequest<UsersEntity>(entityName: "UsersEntity")
        do {
           let fetchedUsers =  try manager.userViewContext.fetch(fetchQuery)
            allUsers.removeAll()
            allUsers = fetchedUsers
            print("there are \(fetchedUsers.count) users now")
        }
        catch let error {
            print("error fetching: \(error)")
        }
        
    }
    
    func fetchApods () {
        
        let fetchQuery = NSFetchRequest<ApodEntity>(entityName: "ApodEntity")
        
        do {
            let fetchedApods = try manager.userViewContext.fetch(fetchQuery)
            allApods.removeAll()
            allApods = fetchedApods
            print("there are \(fetchedApods.count) apods now")
        }
        catch let error  {
            print("error fetching: \(error)")
        }
        
    }
    
    
    func createUser (firstName:String, lastName:String, userName:String, emailAddress:String, password:String) {
        
        let newUser = UsersEntity(context: manager.userViewContext)
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.emailAddress = emailAddress
        newUser.userName = userName
        newUser.password = password
        manager.save()
        fetchUsers()
    }
    
    func deleteUser (at offsets: IndexSet) {
        
            offsets.forEach { Index in
                
                let apod = allApods[Index]
                manager.userViewContext.delete(apod)
                manager.save()
                
            }
        }
    
    
}








