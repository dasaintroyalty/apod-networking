//
//  ProgramDateExtension.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//


import Foundation
import UIKit




extension ProgramDate: Strideable {
    
    
    func advanced(by n: Int) -> ProgramDate {
        var next = self
        
        switch self.month {
            
            case 12 :
            
                if self.day == 31 {
                    next.year =  self.year + 1
                    next.month = 1
                    next.day = 1
                    return next
                }
            
                else {
                    next.year = self.year
                    next.month = self.month
                    next.day = self.day + 1
                    return next
                }
            
            case 1,3,5,7,8,10 :
            
                if self.day == 31 {
                    next.year = self.year
                    next.month = self.month + 1
                    next.day = 1
                    return next
                }
            
                else {
                    next.year = self.year
                    next.month = self.month
                    next.day = self.day + 1
                    return next
                }
            
            case 4,6,9,11:
            
                if self.day == 30 {
                    next.year = self.year
                    next.month = self.month + 1
                    next.day = 1
                    return next
                }
            
                else {
                    next.year = self.year
                    next.month = self.month
                    next.day = self.day + 1
                    return next
                }
        
            case 2:
            
                if self.day == 28 {
                    next.year = self.year
                    next.month = self.month + 1
                    next.day = 1
                    return next
                }
            
                else {
                    next.year = self.year
                    next.month = self.month
                    next.day = self.day
                    return next
                }
            
            default:
                next.year = self.year
                next.month = self.month
                next.day = self.day
                return next
        }
   }

    
    
    func distance(to other: ProgramDate) -> Int {
 
        if self.month == other.month {
                return other.day - self.day
            }
        
        else if (self.month + 1) == other.month {
            return other.month - self.month
        }
        
        else {
            return other.year - self.year
        }
        
    }
}



