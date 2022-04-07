//
//  Active User Extension.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import Foundation
import CoreData
import SwiftUI
import Combine



extension ActiveUserController {


// this method gets all favorited apods by the activeuser from core data
    func favoritesApod() {
        
        if let allFavorites = activeUser?.favoritesApod?.allObjects as? [ApodEntity] {
            favorites.removeAll()
            favorites = allFavorites
            return
        }
      favorites = []
    }



// this method add/delete apods to/from the active user favoritesapod
    func addApod (apod:ApodEntity) {

            if activeUser?.favoritesApod?.contains(apod) ?? false {
                                     removeExistingApod(existingApod: apod)
                                     return
            }

            else  {
                                     addExistingApod(existingApod: apod)
                                     return
            }

    }


// method to remove apod from the user favorited apods
    private func removeExistingApod (existingApod: ApodEntity) {
        activeUser?.removeFromFavoritesApod(existingApod)
        controller.save()
        allUsers.fetchApods()
        favoritesApod()
    }

// method to add apod to the user favorited apods
    
    private func addExistingApod (existingApod: ApodEntity ) {
        activeUser?.addToFavoritesApod(existingApod)
        controller.save()
        allUsers.fetchApods()
        favoritesApod()
    }


// this method creates a new apodentity from the apod content downloaded from the apod server and save to core data
    func createApod(_ apod: ApodServer) {
       
        let vaildApod = ApodModel(title: apod.title, url: apod.url, description: apod.description, date: apod.date, image: apod.image)
        
        
        let newApod = ApodEntity(context: controller.userViewContext)
        newApod.title = vaildApod.title
        newApod.explanation = vaildApod.description
        newApod.date = vaildApod.date
        newApod.apodImage = vaildApod.image?.jpegData(compressionQuality: 0.3)
        newApod.id = vaildApod.id

        save()
        allUsers.fetchApods()
        return
    }


//    this method delete apodentity from core data
    func deleteApod (_ apod: ApodServer) {
        
        guard
            let apodToDelete = allUsers.allApods.first(where: { $0.title == apod.title }) else { return }
        
                controller.userViewContext.delete(apodToDelete)
                controller.save()
                allUsers.fetchApods()
                return
        }

//    this method delete apodentity from core data
    func removeApod (_ apod: ApodEntity) {
        
        controller.userViewContext.delete(apod)
        controller.save()
        allUsers.fetchApods()
        reload.toggle()
        return
        
    }

//    this method checks if an apod is already saved to core data
    func apodSaved (_ apod: ApodServer) -> Bool {
       
        if allUsers.allApods.contains(where: { $0.title == apod.title}) {
            return true
        }
        else {
            return false
        }
      
    }

//this method performs a save action also to core data
    func save() {
        controller.save()
    }


//    this methiod checks if an apod is included in the activeiuser favoritesapod
    
    func isFavorited (apod:ApodEntity) -> Bool {
        
        if (activeUser?.favoritesApod?.contains(where: {($0 as? ApodEntity)?.title == apod.title})) ?? false {
           return true
        }
        else{
            return false
          }
    }


    }


