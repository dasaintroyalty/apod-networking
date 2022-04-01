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
    
    var body: some View {
      
        NavigationView{
            ScrollView{
                LazyVStack{
                    
                    ForEach (users.allApods, id:\.self) { apod in
                        
                       EachApodCreatedView(apod: apod)
                        
                  }
                    
                }
            }.navigationTitle("Astronomy Picture Of The day")
            .navigationBarTitleDisplayMode(.inline)
        }.tabItem {
            Text("APODS")
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


//struct Apod_Created_View_Previews: PreviewProvider {
//    static var previews: some View {
//        Apod_Created_View()
//    }
//}
