//
//  Favorite View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import SwiftUI




struct ThirdTab: View {
    
    @EnvironmentObject var activeUser: ActiveUserController
    @State var showAuth: Bool = false
    @State var dismissed: Bool = false
    
    
    @State var authStartingOffset: CGFloat = UIScreen.main.bounds.height * 0.75
    @State var authChangedOffset: CGFloat = 0
    @State var authEndedOffset: CGFloat = 0
    
    var body: some View {
        
        VStack{
            
            if activeUser.userIsActive ?? false {
                FavoriteView()
            }
            
            else {
                ZStack{
                Text("you need to be authenticated")
                
                    AuthenticationView(showChevron: true)
                    .offset(y: authStartingOffset)
                    .offset(y: authChangedOffset)
                    .offset(y: authEndedOffset)
                    .gesture(
                       DragGesture()
                        .onChanged{ value in
                            authChangedOffset = value.translation.height
                        }
                        .onEnded{ value in
//                            withAnimation(.easeInOut) {
                                
                                if authChangedOffset < -150 {
                                    authStartingOffset = UIScreen.main.bounds.height * 0.15
                                    activeUser.chevronTitle = "chevron.down"
                                }
                                else {
                                    authStartingOffset = UIScreen.main.bounds.height * 0.75
                                    activeUser.chevronTitle = "chevron.up"
                                }
//                            }
                           authEndedOffset = -authChangedOffset
                        }
                    
                    )
                    
                    Spacer()
            }
            }

        }
        .tabItem{
            Text("favorites")
          }
      }

}




struct FavoriteView: View {
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    @State var changeview: Bool = false
    
    @EnvironmentObject var activeUser: ActiveUserController
    @EnvironmentObject var allApods: UsersController
    
    @State var navTitle: String = "Title"
    @State var description:String = ""
    @State var descriptionOpacity: Double = 1.0
    
    @State var LogOutStartingOffset: CGFloat = UIScreen.main.bounds.height
    @State var currentLogoutDragOffset: CGFloat = 0
    @State var endingLogoutDragOffset: CGFloat = 0
    
    @State var toggle: Bool = false
    
  
    
    var body: some View {
       
       NavigationView {
           
               ZStack{
                ScrollView(.vertical, showsIndicators: false){
          
                    favoriteApod
                    
                   }
                   
                   LogOutView()
                       .offset(y: LogOutStartingOffset)
                       .offset(y: currentLogoutDragOffset)
                       .offset(y: endingLogoutDragOffset)
                       .gesture(
                          DragGesture()
                               .onChanged { value in
                                   withAnimation(.easeIn(duration: 0.3)) {
                                       currentLogoutDragOffset = value.translation.height }
                               }
                                .onEnded{ value in
                                    withAnimation(.spring(response: 1.5, dampingFraction: 2, blendDuration: 1)) {
                                            if currentLogoutDragOffset > -50 {
                                                toggle = false
                                                LogOutStartingOffset = UIScreen.main.bounds.height
                                                descriptionOpacity = 1.0
                                              }
                                    }
                                        endingLogoutDragOffset = -currentLogoutDragOffset
                                        
                                }
                             )
                   
                
               }.navigationTitle(navTitle)
                   .navigationBarTitleDisplayMode(.inline)
                        .coordinateSpace(name: "parent")
                        .toolbar{
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button{
                                    if !toggle {
                                        withAnimation(.easeIn(duration: 1.0)) {
                                        LogOutStartingOffset = (UIScreen.main.bounds.height * 0.70)
                                        descriptionOpacity = 0.2
                                        }
                                        toggle = true
                                      
                                    }
                                    else  {
                                        withAnimation(.spring(response: 1.5, dampingFraction: 2, blendDuration: 1)) {
                                            LogOutStartingOffset = UIScreen.main.bounds.height
                                            descriptionOpacity = 1.0
                                        }
                                        toggle = false
                                    }
                                   }
                                    label:{
                                        Image(systemName: "person.crop.circle.fill.badge.xmark")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                            }
                        }
           }.onAppear{
               changeview.toggle()
           }
        
     }
    
  }






extension FavoriteView {
    
    
    var favoriteApod: some View {
        
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {

                LazyHStack(alignment:.top){
                    ForEach(activeUser.favorites, id:\.self) { favorite in

                        GeometryReader{ geometry in

                            Image(uiImage: UIImage(data:favorite.apodImage ?? activeUser.defaultImageData)!).resizable()
                                                              .scaledToFill()
                                                              .frame(maxWidth: UIScreen.main.bounds.width * 0.97)
                                                              .frame(minHeight: UIScreen.main.bounds.width)
                                                              .clipped()
                                                              .overlay{
                                                                  Text(favorite.title ?? "")
                                                              }

                                                            .onReceive(timer, perform: { _ in
                                                                updateTitle(proxy: geometry, apod: favorite)
                                                                          })

                    }.padding(.leading, 5)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)

                    }
                }
            }
   
            VStack{
                Text(description).opacity(descriptionOpacity)
            }.padding(.leading, 5)
             .padding(.trailing, 5)

    
          }
        
    }
    
    
    
    func updateTitle (proxy:GeometryProxy, apod:ApodEntity ) {
      
        if  proxy.frame(in: .global).midX < UIScreen.main.bounds.width * 0.55  &&  proxy.frame(in: .global).midX > UIScreen.main.bounds.width * 0.45 {

            navTitle = apod.title ?? "no title"
            description = apod.explanation ?? "no description available"
            return
        }
        
     }

    
    func alterCurrentOffset () -> CGFloat {
        guard abs(currentLogoutDragOffset) <= abs(LogOutStartingOffset)  else  {
            return LogOutStartingOffset
        }
        return currentLogoutDragOffset
    }
    
    
    
}





struct LogOutView: View {
    
    @EnvironmentObject var activeUser: ActiveUserController

    var body: some View {
        
        VStack{
               Image(systemName: "chevron.down")
               Text("LOG OUT")
                    .italic()
                    .font(.headline)
                    .foregroundColor(.blue)
                    .fontWeight(.heavy)
                    .onTapGesture{
                        activeUser.setUserIsActive(value: false)
                        activeUser.activeUser = nil
                        activeUser.saveActiveUserInfo()
                    }
              Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.secondary)
        
    }
}
