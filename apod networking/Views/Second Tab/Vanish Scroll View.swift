//
//  Vanish Scroll View.swift
//  apod networking
//
//  Created by Olusehinde Samson on 4/6/22.
//

import SwiftUI


// the custom vanishscrollview that draw the content to be display on screen and safely enter vanish state when appropriate

struct VanishScrollView <Content:View>: View  {
    
    let refreshingViewBackColor: Color
    let threshold: CGFloat
    let content: () -> Content
    
    @State var viewState: String = "Showing"
    @State var state: VanishState = .waiting
    let startingThreshold: CGFloat = 50
    
    @State var contentPosition: CGFloat = 0
    
    @State var showVanishState: Bool = false
    @State var offset: CGFloat = 0
    @State var vanishProgressHight: CGFloat = 0
    @State var vanishProgressOpacity: CGFloat = 0
    @State var vanishProgressText:String = ""
    @State var contentHeight: CGFloat = .infinity
    @State var contentOpacity: CGFloat = 1.0
    
    @Binding var scrollToTop: Int

    
    init (refreshingViewBackColor: Color = defaultRefreshingViewBackColor,
          threshold: CGFloat = defaultVanishThreshold,
          @ViewBuilder content: @escaping () -> Content,
          scrollToTop : Binding<Int>) {
        
        self.refreshingViewBackColor = refreshingViewBackColor
        self.threshold = threshold
        self.content = content
        self._scrollToTop = scrollToTop
    }
    
    
    var body: some View {
        
        
       ScrollView {
               
               ZStack(alignment:.top){
                   
                   VanishIndicator(type: .dynamic)
                       .frame(height:0)                   
                   content()
                       .alignmentGuide(.top) { d in
                           d[.bottom]
                       }
                       .frame(maxHeight: contentHeight)
                       .background(ContentScrollingIndicator())
                       .opacity(contentOpacity)
                   
                   VanishProgress(text: vanishProgressText, offset: $offset)
                       .frame(height: vanishProgressHight)
                       .opacity(vanishProgressOpacity)
                       .animation(.easeInOut(duration: 0.5), value: vanishProgressHight)
               }
        }
       .background(VanishIndicator(type: .fixed))
       .onPreferenceChange(VanishPreferenceKey.self) { allValues in
           let fixedY = allValues.last { $0.type == .fixed }?.yAxis ?? 0
           let dynamicY = allValues.last { $0.type == .dynamic }?.yAxis ?? 0
           
           if dynamicY > 500 {
               offset = fixedY - dynamicY
               vanishingMode()
           }
       }
       .onPreferenceChange(ContentPreferenceKey.self) { value in
           contentPosition = value.last ?? 0.0
       }
       .onChange(of: contentPosition, perform: { newValue in
           if (newValue < -800.0 && newValue > -900) && scrollToTop == 1 {
              scrollToTop = 0
           }
       })
       .navigationTitle("")
       .navigationBarTitleDisplayMode(.inline)
       .toolbar {
           HStack{
               Text("Astronomy Picture Of The day").onTapGesture {
                   scrollToTop = 1
               }
            }.padding(.trailing, 50)
           
         }
       
    }
    
    
    
//   method for entering the vanish state mode and turning off the vanish state mode
    func vanishingMode () {
        
        if offset > startingThreshold && state == .waiting && viewState == "Showing"{
                vanishProgressHight = 40
                vanishProgressOpacity = 1.0
                vanishProgressText = "drag up to enter vanish mode"
                state = .dragging
        }
        
        else if offset > threshold && state == .dragging  && viewState == "Showing"{
            vanishProgressText = "release to enter vanish mode"
            state = .primed
        }
        
        else if offset <= startingThreshold && state == .dragging  && viewState == "Showing"{
            vanishProgressText = ""
            vanishProgressHight = 0
            vanishProgressOpacity = 0
            state = .waiting
        }
        
        else if offset < threshold && state == .primed && viewState == "Showing"{
            contentHeight = 0
            contentOpacity = 0
            state = .vanished
            viewState = "Vanished"
        }
        
        else if state == .vanished && viewState == "Vanished" {
//               vanishProgressText = ""
//               vanishProgressHight = 0
//               vanishProgressOpacity = 0
             offset = 0
            state = .waiting
            vanishProgressText = "drag up to turn off vanish mode"
        }
        else if state == .waiting && offset > startingThreshold && viewState == "Vanished" {
            
//               vanishProgressHight = 40
//               vanishProgressOpacity = 1.0
            state = .dragging
        }
        
        else if offset > threshold && state == .dragging && viewState == "Vanished" {
            vanishProgressText = "release to turn off vanish mode"
            state = .primed
        }

        
        else if offset < threshold && state == .primed && viewState == "Vanished" {
            vanishProgressText = ""
            vanishProgressHight = 0
            vanishProgressOpacity = 0
            contentHeight = .infinity
            contentOpacity = 1.0
            state = .showing
            viewState = "Showing"
        }
        
        else if state == .showing && viewState == "Showing" {
            offset = 0
            state = .waiting
        }
        
    }
}



// the view for showing when the vanish state would be on and off

struct VanishProgress : View {
    
    var text: String
    @Binding var offset: CGFloat
    @State var trimColor: Color = .blue
    
    var body: some View {
       
        VStack{
                ZStack{
                    Circle()
                        .stroke(Color.white, style: StrokeStyle(lineWidth:10))
                        .frame(width: 35, height: 35)
                        
                    
                    Circle()
                        .trim(from: 0, to: makeTrim(offset: offset))
                        .stroke(trimColor, style: StrokeStyle(lineWidth: 5))
                        .rotationEffect(.init(degrees: -90))
                        .frame(width: 40, height: 40)
                }
            
            Text(text)
        }
        .padding(.top, 20)
        .onChange(of: offset) { newValue in
            updateTrimColor()
        }
    }
    
    func makeTrim (offset: CGFloat) -> CGFloat{
        if offset <= 170 {
         return (CGFloat(offset/170))
        }
        else {
            return 1.0
        }
    }
    
    func updateTrimColor (){
        if offset >= 170 {
            trimColor = .green
        }
        else if offset < 170 {
            trimColor = .blue
        }
            
    }
}





/*
struct Vanish_Scroll_View_Previews: PreviewProvider {
    static var previews: some View {
        Vanish_Scroll_View()
    }
}*/
