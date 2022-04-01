//
//  apod_networkingApp.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import SwiftUI

@main
struct apod_networkingApp: App {
    

    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear{
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    } 
}
