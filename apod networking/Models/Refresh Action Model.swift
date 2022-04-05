//
//  Refresh Action Model.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/30/22.
//

import Foundation
import SwiftUI



class RefreshingAction: ObservableObject {
    
    @Published  var isPerforming:Bool = false
    
    func perform (_ action: RefreshAction) {
    
        Task{
         await refresh(action)
        }
    }
    
  
//    the refresh method that makes use of the environmental refreshaction if present
    func refresh (_ action: RefreshAction) async {
        
        guard !isPerforming else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.isPerforming = true
        }
       
        
        await action()

        DispatchQueue.main.async { [weak self] in
            
            self?.isPerforming = false
            
        }
       
    
        
    }
    
}


 enum ScrollingType {
    
    case fixed
    case dynamic
}

// struct to represent the position of the customscrolling indicator
 struct ScrollingPosition: Equatable {
    
    let type: ScrollingType
    let yAxis: CGFloat
}


// the scrolling view preference key struct

 struct ScrollingPreferenceKey: PreferenceKey {

    typealias Value = [ScrollingPosition]
    
    static var defaultValue = [ScrollingPosition]()
    
    static func reduce(value: inout [ScrollingPosition], nextValue: () -> [ScrollingPosition]) {
        value.append(contentsOf: nextValue())
    }
    
}


// the customscrollingindicator view that would always report a value for the scrollingpreference key
 struct CustomScrollingIndicator: View {
   
    let type: ScrollingType
    
    var body: some View {
        GeometryReader { proxy in
            
            Color.clear
                .preference(key: ScrollingPreferenceKey.self, value: [ScrollingPosition(type: type, yAxis: proxy.frame(in: .global).minY)])
        }
    }
    
}


//enumeration to track the state of the refreshing action
enum RefreshState {
    case waiting, primed, refreshing
}


public typealias FinishedRefreshing = () -> Void


public let defaultRefreshingViewBackColor = Color(UIColor.systemBackground)

public let defaultRefreshThreshold: CGFloat = 60
