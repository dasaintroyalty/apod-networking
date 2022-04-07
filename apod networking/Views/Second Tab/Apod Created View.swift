//
//  Apod Created View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/30/22.
//

import SwiftUI



struct ApodCreatedView: View {
    
    @EnvironmentObject var activeUser : ActiveUserController
    @EnvironmentObject var users: UsersController
    
    @State var scrollToTop = 0
    
    var body: some View {
      
        NavigationView{
            VStack{
               
                VanishScrollView(content: {
                    AllApodView(scrollToTop: $scrollToTop)
                }, scrollToTop: $scrollToTop)
                
        }
            
        }.searchable(text: $activeUser.apodCreatedSearch, prompt: "Search apods")
         .tabItem {
            Text("APODS")
        }
         
        
    }
    
}




struct AllApodView : View {
    
    @EnvironmentObject var activeUser : ActiveUserController
    @EnvironmentObject var users: UsersController
    
    @Environment(\.isSearching) var isSearching
    
    @State var showSortingAlert: Bool = false
    @Binding var scrollToTop: Int
    
    var body: some View {
        
        LazyVStack{

                HStack {
                    Image(systemName: "shuffle")
                        .onTapGesture {
                            users.allDynamicApods = users.allApods.shuffled()
                            users.allApods = users.allDynamicApods
                        }
                    Spacer()
                    
                    Image(systemName: "slider.horizontal.3")
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSortingAlert.toggle()
                            }
                        }
                    
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
        

            SortingApodView()
                .frame(maxHeight: showSortingAlert ? .infinity : 0)
                .opacity(showSortingAlert ? 1.0 : 0)
            ScrollViewReader { proxy in
                
                ForEach (users.allApods, id:\.self) { apod in
                    
                        EachApodCreatedView(apod: apod)
                        .id((users.allApods.firstIndex(of: apod) ?? 0) + 1)
                    
                }.onChange(of: scrollToTop) { newValue in
                    if newValue == 1 {
                        withAnimation(.spring()) {
                            proxy.scrollTo(newValue, anchor: .center) }
                        }
                       
                }
                
            }
           
            
            
            
        }.opacity(activeUser.apodCreatedSearch.isEmpty ? 1.0 : 0.2)
         .overlay{
            if isSearching && !activeUser.apodCreatedSearch.isEmpty {
                  SearchedApodView()
                }
            }
        
    }
    
   
}


struct EachApodCreatedView: View {
    
    @EnvironmentObject var activeUser : ActiveUserController
    
    var apod: ApodEntity
    @State var toFullView:Bool = false
    
    
    
    var body: some View {
        
        VStack{
            
            Text(apod.title ?? "no title")
            
            HStack{
                Spacer()
                Image(systemName: "xmark.circle.fill").resizable()
                                                     .frame(width: 20, height: 20)
                                                     .onTapGesture{
                                                         activeUser.removeApod(apod)
                                                    }
            }
            
            VStack{
                Image(uiImage: UIImage(data: apod.apodImage ?? activeUser.defaultImageData)!).resizable()
                                                                                              .scaledToFill()
                                                                                              .frame(maxWidth:.infinity)
    
            }.padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
             .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 2))
             .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))

 
            HStack{
                Spacer()
                Text(apod.date ?? "nil").font(.caption)
            }.padding(.bottom, 10)
           
           EachApodCreatedButtonView(apod: apod)
            
           NavigationLink(destination: ApodCreatedSecondView(apod: apod),isActive: $toFullView, label: {EmptyView()})
            
            
        }.padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
         .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 2))
         .padding(EdgeInsets(top: 5, leading: 5, bottom: 10, trailing: 5))
         .onTapGesture{
              toFullView.toggle()
          }
        
    }
}





struct EachApodCreatedButtonView: View {
    
    
    @EnvironmentObject var activeUser : ActiveUserController
    var apod: ApodEntity
    
    @State var showAuthView: Bool = false
    
    
    
    var body: some View {
        
        HStack {
            Text("favorite this").padding(.trailing, 10)
            
            Button{
                activeUser.userActive() ? activeUser.addApod(apod: apod) : showAuthView.toggle()
               }
                label:{
                    Image("like").resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .colorMultiply(activeUser.isFavorited(apod: apod) ? withAnimation{.red} : withAnimation{.white})
                   }
            
            .sheet(isPresented: $showAuthView){
                AuthenticationView(showChevron: false)
                        }
            Spacer()
            
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        
    }
}





struct ApodCreatedSecondView: View {
    
    @EnvironmentObject var activeUser : ActiveUserController
    var apod: ApodEntity
    
    var body: some View {
        
        ScrollView{
            
            VStack {
              
                Image(uiImage: UIImage(data: apod.apodImage ?? activeUser.defaultImageData)!).resizable()
                                                                                             .scaledToFill()
                                                                                             .frame(maxWidth:.infinity)
            
                Text(apod.explanation ?? "nil")
                
                HStack{
                    Spacer()
                    Text(apod.date ?? "nil")
                }
                
            }.navigationTitle(apod.title ?? "no title")
    
        }
    }
}




struct SearchedApodView : View {
    
    @EnvironmentObject var users: UsersController
    @EnvironmentObject var activeUser : ActiveUserController
    
    
    var body: some View {
        
        
        ScrollView {
            
            VStack {
                
                ForEach (activeUser.filteredApods, id:\.self) {  apod in
                    
                    EachSearchedApod(apod: apod)
                      
                }
            }.background(Color(UIColor.systemBackground))
        }
        
    }
}


struct EachSearchedApod: View {
    
    var apod: ApodEntity
    @EnvironmentObject var activeUser : ActiveUserController
    @State var toFullView:Bool = false
    
    var body: some View {
        
        HStack {
            Text(apod.title ?? "no tittle").bold()
                .lineLimit(2)
                .padding(.leading, 5)
            Spacer()
            Image(uiImage: UIImage(data: apod.apodImage ?? activeUser.defaultImageData)!).resizable()
                .frame(width: 60, height: 60)
                .scaledToFit()
                .clipped()

            NavigationLink(destination: ApodCreatedSecondView(apod: apod), isActive: $toFullView, label: { EmptyView()})
            
        }//.background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
        .background(Color(UIColor.systemBackground))
        .padding(.leading, 5)
        .padding(.trailing, 5)
        .onTapGesture {
            toFullView.toggle()
        }
    }
}






//struct Apod_Created_View_Previews: PreviewProvider {
//    static var previews: some View {
//        Apod_Created_View()
//    }
//}
