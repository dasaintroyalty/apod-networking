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



    func favoritesApod() {
        
        if let allFavorites = activeUser?.favoritesApod?.allObjects as? [ApodEntity] {
            favorites.removeAll()
            favorites = allFavorites
            return
        }
      favorites = []
    }




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



    private func removeExistingApod (existingApod: ApodEntity) {
        activeUser?.removeFromFavoritesApod(existingApod)
        controller.save()
        allUsers.fetchApods()
        favoritesApod()
    }

    private func addExistingApod (existingApod: ApodEntity ) {
        activeUser?.addToFavoritesApod(existingApod)
        controller.save()
        allUsers.fetchApods()
        favoritesApod()
    }



    func createApod(_ apod: ApodServer) {
       
        let vaildApod = ApodModel(title: apod.title, url: apod.url, description: apod.description, date: apod.date, image: apod.image)
        
        
        let newApod = ApodEntity(context: controller.userViewContext)
        newApod.title = vaildApod.title
        newApod.explanation = vaildApod.description
        newApod.date = vaildApod.date
        newApod.apodImage = vaildApod.image?.jpegData(compressionQuality: 0.3)
        newApod.id = vaildApod.id

        save()
        print("how about after saving  whats wrong")
        allUsers.fetchApods()
        reload.toggle()
        return
    }


    func deleteApod (_ apod: ApodServer) {
        
        guard
            let apodToDelete = allUsers.allApods.first(where: { $0.title == apod.title }) else { return }
        
                controller.userViewContext.delete(apodToDelete)
                controller.save()
                allUsers.fetchApods()
                reload.toggle()
                return
        }

    func removeApod (_ apod: ApodEntity) {
        
        controller.userViewContext.delete(apod)
        controller.save()
        allUsers.fetchApods()
        reload.toggle()
        return
        
    }

    func apodSaved (_ apod: ApodServer) -> Bool {
       
        if allUsers.allApods.contains(where: { $0.title == apod.title}) {
            return true
        }
        else {
            return false
        }
      
    }


    func save() {
        controller.save()
    }


    func isFavorited (apod:ApodEntity) -> Bool {
        
        if (activeUser?.favoritesApod?.contains(where: {($0 as? ApodEntity)?.title == apod.title})) ?? false {
           return true
        }
        else{
            return false
          }
    }


    }


