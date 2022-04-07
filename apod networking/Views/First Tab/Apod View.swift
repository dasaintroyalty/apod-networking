//
//  Apod View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//


import SwiftUI



struct ApodView: View {

    
    var body: some View{
        
        NavigationView{
            
                CustomScrollView {
                    ApodContentView()
                }
            
        }
        .tabItem{
            Text("Home")
          }
    }
}







//the content view that is drawn on screen by the customscrollview

struct ApodContentView: View {
    
    @EnvironmentObject var users: UsersController
    @EnvironmentObject var active: ActiveUserController
    @EnvironmentObject var vm: ApodDataService
    
    let rangeToStartFrom = Calendar.current.date(from: DateComponents(year: 2014))!
    let rangeToEndWith = Calendar.current.date(from: DateComponents(year: 2022))!
    @State var reload = false
    
    
    var body: some View {
        
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
                                            .frame(width: 35, height: 20)
                                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                            .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 2))
                                            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                            
                                 }
                    
                    }.lineLimit(1)
                     .minimumScaleFactor(0.3)
                  
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
 }



//the view of each apods fetched from apod server

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




//the detailed view for each apod

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
   
    @EnvironmentObject var vm: ApodDataService
    @Binding var error: Error?

    
    var body: some View{
        
        VStack {
          
            if let error = error {
                
                   Text(error.localizedDescription).bold()
                
                    Button{
                        self.error = nil
                        vm.displaying = true
                        vm.state = .waiting
                        
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
                 
                Button(
                    action:{
                        if let action = action {
                            refreshAction.perform(action) }
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

