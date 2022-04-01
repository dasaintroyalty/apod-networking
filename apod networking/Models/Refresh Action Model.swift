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
    
    
    func refresh (_ action: RefreshAction) async {
        
        guard !isPerforming else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.isPerforming = true
            print("hmmmmmmmm")
        }
       
        
        await action()
        print("performing any action 🧐")

       isPerforming = false
    
        
    }
    
}
