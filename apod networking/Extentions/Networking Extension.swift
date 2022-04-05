//
//  Networking Extension.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine



extension ApodDataService {



//the fetching of image from apod server function
func fetchImage (with url: URL) async  -> UIImage? {
   
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let imageData = UIImage(data: data) else { return nil }
        return imageData
    } catch let error {
        print("there was an error getting the image associated with this data: \(error)")
        return nil
    }
    
}



//thus method uses async method of urlsession to dynamically download data from apod server

func dataData (url: URL) async throws -> ApodServer {
    let decoder = JSONDecoder()
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let response = response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
              throw URLError(.badServerResponse)
          }
    
    do {
       let decoded = try decoder.decode(ApodServer.self, from: data)
        return decoded
    } catch let error {
        print("error decoding data: \(error)")
        throw PhotoInfoError.imageDataMissing
    }
}


//method to transfer the date unput query to an appropriate query date for the urlsession task
func getDateInput () -> (ProgramDate, ProgramDate) {
    
    let startingDate = (Calendar.current.dateComponents([.year, .month, .day], from: startingFrom))
    let StartingDateYear = startingDate.value(for: .year)
    let StartingDateMonth = startingDate.value(for: .month)
    let StartingDateDay = startingDate.value(for: .day)
    
    let apodStartingDate = ProgramDate(year: StartingDateYear ?? 2022, month: StartingDateMonth ?? 3, day: StartingDateDay ?? 1)
    
    
    let endingDate = (Calendar.current.dateComponents([.year, .month, .day], from: endingAt))
    let endingDateYear = endingDate.value(for: .year)
    let endingDateMonth = endingDate.value(for: .month)
    let endingDateDay = endingDate.value(for: .day)
   
    let apodEndingDate = ProgramDate(year: endingDateYear ?? 2022, month: endingDateMonth ?? 3, day: endingDateDay ?? 20)
   print("are you reaching here")
    
    return (apodStartingDate, apodEndingDate)
    
}

//    this method create a url instance from a date component
func createUrl(eachDateComponent: String) -> URLComponents {
    
    var urlcomponents = URLComponents(string: "https://api.nasa.gov")!
        urlcomponents.path = "/planetary/apod"

    let eachDateQueryItem = ["api_key" : "Rn1LR0mAknJ2SP3Z6ZlunJmgacrsQctbhIp41wIP", "date" : eachDateComponent]
    
    urlcomponents.queryItems = eachDateQueryItem.map{URLQueryItem(name: $0.key, value: $0.value)}
    print("how about here")
    return urlcomponents
}


}



