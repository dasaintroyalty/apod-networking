//
//  Apod View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//


import SwiftUI


struct ApodView: View {
    
    @EnvironmentObject var users: UsersController
    @EnvironmentObject var active: ActiveUserController
    @EnvironmentObject var vm: ApodDataService
    
    let rangeToStartFrom = Calendar.current.date(from: DateComponents(year: 2014))!
    let rangeToEndWith = Calendar.current.date(from: DateComponents(year: 2022))!
    @State var reload = false
    
    
    var body: some View {
        
        NavigationView{
            ScrollView{
                VStack {
                    HStack{
                        DatePicker("From", selection: $vm.startingFrom , in: rangeToStartFrom...rangeToEndWith, displayedComponents: [.date])
                        
                        DatePicker("To", selection: $vm.endingAt , in: rangeToStartFrom...rangeToEndWith, displayedComponents: [.date])
                        
                        Button{
                        vm.error = nil
                        vm.dynamicRequest()
                        reload = true
                        }
                            label:{
                               Text("Load")
                                }
                    }
                  
                    VStack{
                        
                        if vm.fetching && !vm.displaying {
                           
                            ProgressView()
                            
                        }
                        
                        LazyVStack{
                            ForEach (vm.allApodContents, id:\.id) { apod in
                                
                               EachApodView(apod: apod)
                                
                          }
                        }
                        
                    }
                }
                
            }.overlay(alignment: .center)
            {
              if vm.error != nil {
                            ErrorView(error: $vm.error)
                  }
              }

            
        }.refreshable{
            vm.error = nil
            vm.dynamicRequest()
            reload = true
            }
        .tabItem{
            Text("Home")
          }
    }

}


struct EachApodView : View {
    @EnvironmentObject var vm: ApodDataService
    @EnvironmentObject var activeUser : ActiveUserController
    
    var apod: ApodServer
    @State var toFullView:Bool = false
    
    var body: some View {
            
            VStack{
                
                Text("\(apod.title)")
                
                HStack{
                    Spacer()
                    Image(systemName: activeUser.apodSaved(apod) ? "plus.circle.fill" : "plus.circle").resizable()
                                                    .frame(width: 20, height: 20)
                                                    .onTapGesture{
                                                        activeUser.apodSaved(apod) ? activeUser.deleteApod(apod) : activeUser.createApod(apod)
                                                    }
                }
                
                VStack{
                    Image(uiImage: apod.image ?? activeUser.defaultImage).resizable()
                                              .scaledToFill()
                                              .frame(maxWidth:.infinity)
                    
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
                 .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 2))
                 .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))

     
                HStack{
                    Spacer()
                    Text(apod.date).font(.caption)
                }.padding(.bottom, 10)
               
                
                NavigationLink(destination: SecondView(apod: apod),isActive: $toFullView, label: {EmptyView()})
                
                
            }.padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
          .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 2))
          .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
          .onTapGesture{
              toFullView.toggle()
          }
            
    }
}





struct SecondView: View {
    
    @EnvironmentObject var activeUser : ActiveUserController
    var apod: ApodServer
    
    var body: some View {
        
        ScrollView{
            
            VStack {
              
                Image(uiImage: apod.image ?? activeUser.defaultImage).resizable()
                                                                     .scaledToFill()
                                                                     .frame(maxWidth:.infinity)
                
                Text(apod.description)
                
                HStack{
                    Spacer()
                    Text(apod.date)
                }
                
            }.navigationTitle(apod.title)
        }
    }
}






struct ErrorView: View {
   
    @Binding var error: Error?
    
    var body: some View{
        
        VStack {
          
            if let error = error {
                   Text(error.localizedDescription).bold()
                
                    Button{
                        self.error = nil
                    }
                        label:{
                              Text("dismiss")
                            }
                
                    RefreshButton(error: $error)
                
            }
        }
        
    }
}



struct RefreshButton: View {
    
    var title: LocalizedStringKey = "Retry"
    @EnvironmentObject var refreshAction: RefreshingAction
    
    @Environment(\.refresh) private var action
    
    @Binding var error: Error?
    
    var body: some View {
       
        VStack{
            if let action = action {
                
                Button(
                    action:{
    //                    refreshAction.isPerforming = true
                         refreshAction.perform(action)
                    },
                    label:{
                       VStack{
                            if refreshAction.isPerforming {
                              ProgressView()
                            }
                            else {
                                Text(title)
                            }
                        }
                    }
                ).disabled(refreshAction.isPerforming)
            }
        }
        
    }
}




//                        HStack(spacing:3){
//                            Text("loading")
//                            Circle()
//                                .offset(y: vm.count == 1 ? -20 : 0)
//                            Circle()
//                                .offset(y: vm.count == 2 ? -20 : 0)
//                            Circle()
//                                .offset(y: vm.count == 3 ? -20 : 0)
//                        }.frame(width: 100)
//                        .foregroundColor(.gray)



