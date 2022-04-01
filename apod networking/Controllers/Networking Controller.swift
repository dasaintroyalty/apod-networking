//
//  Networking Controller.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class ApodDataService: ObservableObject {
  
    @Published var startingFrom = Calendar.current.date(from: DateComponents(year: 2020, month: 4, day: 15))!
    @Published var endingAt = Calendar.current.date(from: DateComponents(year: 2020, month: 4, day: 20))!
    
    @Published var allApodContents:[ApodServer] = []
    @Published var error: Error? = nil
    
    init() {
       dynamicRequest()
       print("this view is active")
       startTimer()
    }
    
    deinit{
        print("this view is inactive")
    }
    
    @Published var displaying: Bool = false
    @Published var fetching: Bool = false
    
    @Published var count:Int = 0
    var cancellables = Set<AnyCancellable>()
    var outputApods:AnyCancellable?
    

    func startTimer () {
     
        Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self]_ in
                
                        guard let self = self else {return}
                        withAnimation(.easeInOut(duration: 0.5)) {
                        self.count = self.count == 3 ? 1 : self.count + 1
                        }
                        if self.displaying {
                            for timer in self.cancellables {
                                timer.cancel()
                            }
                        }

                    })
            .store(in: &cancellables)
    }
    
    
    func dynamicRequest () {
    
        guard error == nil else { return }
        
        DispatchQueue.main.async {[weak self] in
            self?.allApodContents = []
        }
          Task {
                do {
                    try await request()
                    DispatchQueue.main.async { [weak self] in
                        self?.error = nil
                    }
                   
                } catch  {
                    DispatchQueue.main.async {
                        self.error = error
                        print("\(error)")
                    }
                   
                }

            }
            
            
        
    }
    
    
    
    func request () async throws {
        
        DispatchQueue.main.async { [weak self] in
            self?.fetching = true
            self?.displaying = false
         }
       
        try await apodDataDownload()
        
        print("are you getting here")
        
        
     }
  
    func apodDataDownload () async throws {
        
        
        let(apodStartingDate, apodEndingDate) = getDateInput()

        for date in stride(from: apodStartingDate, to: apodEndingDate, by: 1) {
        
            let eachDateComponent = "\(date.year)-\(date.month)-\(date.day)"
            let urlComponents = createUrl(eachDateComponent: eachDateComponent)
            print("ehats spsoskssjksksk")
            guard let url = URL(string: "\(urlComponents)") else { continue }
            print("sjdjddjmdjdjdjdndmnkdkdmkdmdmdkmdmdkdm")
            let apodDownloaded = try await dataTaskPublisher(url: url)
            print("ddjsn")
            let validApodDownloaded = await updateInterface(apod: apodDownloaded)
 
            DispatchQueue.main.async { [weak self] in
                self?.displaying = true
                self?.allApodContents.append(validApodDownloaded)
            }
        }
        
     
    }
    
    
    func updateInterface (apod: ApodServer) async -> ApodServer {
        
        guard let apodImage = await fetchImage(with: apod.url) else { return apod }
        var validApod = apod
        validApod.image = apodImage
        return validApod
        
    }
    
  }
    
    
    

