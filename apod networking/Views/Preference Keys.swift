//
//  Preference Keys.swift
//  apod networking
//
//  Created by Olusehinde Samson on 4/7/22.
//

import Foundation
import SwiftUI

 

// the scrolling view preference key struct

 struct ScrollingPreferenceKey: PreferenceKey {

    typealias Value = [ScrollingPosition]
    
    static var defaultValue = [ScrollingPosition]()
    
    static func reduce(value: inout [ScrollingPosition], nextValue: () -> [ScrollingPosition]) {
        value.append(contentsOf: nextValue())
    }
    
}



// the customscrollingindicator view that would always report values for the scrollingpreference key
 struct CustomScrollingIndicator: View {
   
    let type: ScrollingType
    
    var body: some View {
        GeometryReader { proxy in
            
            Color.clear
                .preference(key: ScrollingPreferenceKey.self, value: [ScrollingPosition(type: type, yAxis: proxy.frame(in: .global).minY)])
        }
    }
    
}


//the vanish preference key struct
struct VanishPreferenceKey: PreferenceKey {
   
    typealias value = [ScrollingPosition]
    
    static var defaultValue = [ScrollingPosition]()
    
    static func reduce(value: inout [ScrollingPosition], nextValue: () -> [ScrollingPosition]) {
        value.append(contentsOf: nextValue())
    }
    
}


// the vanishindicator view that would always report values for the vanishpreference key
struct VanishIndicator: View {
    
    var type: ScrollingType
    
    var body: some View {
        
        GeometryReader { proxy in
            
            Color.clear
                .preference(key: VanishPreferenceKey.self, value: [ScrollingPosition(type: type, yAxis: proxy.frame(in: .global).maxY)])
            
        }
    }
}


//the content preference key struct
struct ContentPreferenceKey: PreferenceKey {
    
    static var defaultValue = [CGFloat]()
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        defaultValue.append(contentsOf: nextValue())
    }
    
}


// the contentscrollingindicator view that would always report values for the vanishpreference key

struct ContentScrollingIndicator : View {
    
    
    var body: some View {
        
        VStack{
            
            GeometryReader  { geo in
                Color.clear
                    .preference(key: ContentPreferenceKey.self, value: [geo.frame(in: .global).minY])
            }
        }
    }
}

