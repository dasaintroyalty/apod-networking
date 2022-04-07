//
//  Custom Scroll View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 4/6/22.
//

import SwiftUI



//the custom scroll view that draws the content to be displayed and safely refresh the content state when appropriate

struct CustomScrollView <Content>: View where Content:View {
   
    @EnvironmentObject var vm: ApodDataService
    
    let refreshingViewBackColor: Color
    let threshold: CGFloat
    let content: () -> Content
    
    @State private var offfset: CGFloat = 0

    @State var reload = false
    
    init(refreshingViewBackColor: Color = defaultRefreshingViewBackColor,
         threshold: CGFloat = defaultRefreshThreshold,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.refreshingViewBackColor = refreshingViewBackColor
        self.threshold = threshold
        self.content = content
    }
    
    
    
    var body: some View {
            
            ScrollView {
                
                ZStack (alignment: .top) {
                    
                    CustomScrollingIndicator(type: .dynamic)
                        .frame(height:0)
                    
                    content()
                        .alignmentGuide(VerticalAlignment.top) { d in
//                            (vm.state == .refreshing) ? -threshold + offfset : 0
                            d[.top]
                        }
                    
                }
                
            }
            .background(CustomScrollingIndicator(type: .fixed))
            .onPreferenceChange(ScrollingPreferenceKey.self) { allValues in
                let fixedY = allValues.last { $0.type == .fixed }?.yAxis ?? 0.0
                let dynamicY = allValues.last { $0.type == .dynamic }?.yAxis ?? 0.0
                
                offfset = dynamicY - fixedY
                
                if vm.state != .refreshing {
                        
                    if offfset > threshold && vm.state == .waiting {
                            DispatchQueue.main.async {
                                vm.state = .primed }
                        }
                        
                    else if offfset < threshold && vm.state == .primed {
                            
                        vm.state = .refreshing
                        vm.error = nil
                        
                                    DispatchQueue.global(qos: .background).async {
                                        
                                                    vm.refreshingRequest { }
                                        
                                                   }
                                    }
                    
                        }
                
               }
            .navigationTitle("APOD")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .center)  {
                
                  if vm.error != nil {
                                ErrorView(error: $vm.error)
                      }
                  }
            .refreshable{
                vm.error = nil
                vm.dynamicRequest()
                reload = true
              }
        }
    }



/*struct Custom_Scroll_View_Previews: PreviewProvider {
    static var previews: some View {
        Custom_Scroll_View()
    }
}*/
