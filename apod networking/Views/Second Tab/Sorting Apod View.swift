//
//  Sorting Apod View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 4/6/22.
//

import SwiftUI





struct SortingApodView: View {
    
    @EnvironmentObject var activeUser : ActiveUserController
    @EnvironmentObject var users: UsersController
    
    @State var sortingDateHeight: CGFloat = 0
    @State var sortingNameHeight: CGFloat = 0
    @State var selectedSorting: String = "None"
    
    var body: some View {
        
        HStack{
            Spacer(minLength: 240)
                
            VStack(alignment:.leading, spacing: 0){
                
                Text("SORT BY").fontWeight(.bold)
                                   .padding(.bottom, 10)
                HStack{
                      Image(systemName: "checkmark.seal.fill").opacity(selectedSorting == "None" ? 0.8 : 0)
                      Text("None")
                    }.onTapGesture {
                        selectedSorting = "None"
                        SortingApods(selectedSorting)
                    }
                Divider().padding(.bottom, 5)
                    
                ZStack(alignment:.topLeading){
                   HStack{
                      Text("Name").fontWeight(.semibold)
                      Spacer()
                      Image(systemName: sortingNameHeight == 0 ? "chevron.forward.circle.fill" : "chevron.down.circle.fill")
                                                                    .onTapGesture {
                                                                            if sortingNameHeight == 0 { sortingNameHeight = 40 }
                                                                            else {sortingNameHeight = 0 }
                                                                        }
                            }
                   VStack(alignment:.leading){
                            
                        HStack{
                            Image(systemName: "checkmark.seal.fill").opacity(selectedSorting == "NameAscending" ? 0.8 : 0)
                            Text("Ascending")
                            }.opacity(sortingNameHeight == 0 ? 0 : 1.0)
                             .onTapGesture {
                                 selectedSorting = "NameAscending"
                                 SortingApods(selectedSorting)
                                 }
                        HStack{
                            Image(systemName: "checkmark.seal.fill").opacity(selectedSorting == "NameDescending" ? 0.8 : 0)
                            Text("Descending")
                            }.opacity(sortingNameHeight == 0 ? 0 : 1.0)
                             .onTapGesture {
                                    selectedSorting = "NameDescending"
                                    SortingApods(selectedSorting)
                                }
                            
                        }.frame(height: sortingNameHeight)
                         .alignmentGuide(.top) { d in
                                    sortingNameHeight == 40 ? -25 : 0
                                   }
                    }.padding(.bottom, 5)
                    
                    ZStack(alignment:.topLeading){
                        HStack{
                            Text("Date").fontWeight(.semibold)
                            Spacer()
                            Image(systemName: sortingDateHeight == 0 ? "chevron.forward.circle.fill" : "chevron.down.circle.fill")
                                                                        .onTapGesture {
                                                                            if sortingDateHeight == 0 { sortingDateHeight = 40 }
                                                                            else { sortingDateHeight = 0 }
                                                                        }
                            }
                        VStack(alignment:.leading){
                                
                            HStack{
                                Image(systemName: "checkmark.seal.fill").opacity(selectedSorting == "DateAscending" ? 0.8 : 0)
                                Text("Ascending")
                                }.opacity(sortingDateHeight == 0 ? 0 : 1.0)
                                 .onTapGesture {
                                    selectedSorting = "DateAscending"
                                     SortingApods(selectedSorting)
                                }
                            HStack{
                                Image(systemName: "checkmark.seal.fill").opacity(selectedSorting == "DateDescending" ? 0.8 : 0)
                                Text("Descending")
                                }.opacity(sortingDateHeight == 0 ? 0 : 1.0)
                                 .onTapGesture {
                                    selectedSorting = "DateDescending"
                                    SortingApods(selectedSorting)
                                }
                            
                        }.frame(height: sortingDateHeight)
                         .alignmentGuide(.top) { d in
                                 sortingDateHeight == 40 ? -25 : 0
                             }
                    }
                    
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                 .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 2))
                 .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 5))
                
            }
        
    }
   
//    method for sorting apods to display on screen
    func SortingApods (_ type: String) {
        switch type {
            
        case "None":
            users.allApods = users.allApodsCopy
            
        case "NameAscending":
            users.allDynamicApods = users.allApods.sorted(by: {($0.title ?? "") < ($1.title ?? "")})
            users.allApods = users.allDynamicApods
            
        case "NameDescending":
            users.allDynamicApods = users.allApods.sorted(by: {($0.title ?? "") > ($1.title ?? "")})
            users.allApods = users.allDynamicApods
            
        case "DateAscending":
            users.allDynamicApods = users.allApods.sorted(by: {($0.date ?? "") < ($1.date ?? "")})
            users.allApods = users.allDynamicApods
            
        case "DateDescending":
            users.allDynamicApods = users.allApods.sorted(by: {($0.date ?? "") > ($1.date ?? "")})
            users.allApods = users.allDynamicApods
            
        default:
            users.allApods = users.allApodsCopy
        }
    }
    
    
    
}


/*struct Sorting_Apod_View_Previews: PreviewProvider {
    static var previews: some View {
        Sorting_Apod_View()
    }
}*/
