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


//enumeration to track the state of the refreshing action
enum RefreshState {
    case waiting, primed, refreshing
}



    enum VanishState {
        case waiting
        case dragging
        case primed
        case vanished
        case showing
}
    

public typealias FinishedRefreshing = () -> Void


public let defaultRefreshingViewBackColor = Color(UIColor.systemBackground)

public let defaultRefreshThreshold: CGFloat = 60

public let defaultVanishThreshold: CGFloat = 170
