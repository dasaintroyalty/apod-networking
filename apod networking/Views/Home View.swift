//
//  Home View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = ApodDataService()
    @StateObject var users = UsersController()
    @StateObject var active = ActiveUserController()
    @StateObject var refreshAction = RefreshingAction()
    var body: some View {
        
        TabView {
            
            ApodView()
            
            ApodCreatedView()
            
            ThirdTab()
            
         }.environmentObject(vm)
          .environmentObject(users)
          .environmentObject(active)
          .environmentObject(refreshAction)
            
    
    }
}
