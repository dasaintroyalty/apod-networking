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

//class that implements the networking task of the apod server

class ApodDataService: ObservableObject {
  
    @Published var startingFrom = Calendar.current.date(from: DateComponents(year: 2020, month: 4, day: 15))!
    @Published var endingAt = Calendar.current.date(from: DateComponents(year: 2020, month: 4, day: 20))!
    
    @Published var allApodContents:[ApodServer] = []
    @Published var error: Error? = nil
    
    @Published var state = RefreshState.waiting
    
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
    
//a timer that publishes every 0.5 seconds,   this timer was later discarded
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
    
//   a dynamic request to the server to fetch all requested apod through the date patameter
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
    
  
//    this method is the same as the dynamicRequest with just an escaping closure because its being called when the refresh action is triggered
    
    func refreshingRequest (completion: @escaping FinishedRefreshing){
        
        guard error == nil else { return }
        
        DispatchQueue.main.async {[weak self] in
            self?.allApodContents = []
        }
     
        Task{
            do {
                 try await request()
                 DispatchQueue.main.async { [weak self] in
                            self?.error = nil
                            completion()
                       }
                       
                } catch  {
                        DispatchQueue.main.async {
                            self.error = error
                            print("\(error)")
                            completion()
                        }
                       
                    }

        }
    }
    
    
//   the request method to download apods content from apod server
    func request () async throws {
        
        DispatchQueue.main.async { [weak self] in
            self?.fetching = true
            self?.displaying = false
            self?.state = .refreshing
         }
       
        try await apodDataDownload()
        
        print("are you getting here")
        
        
     }
  
    
//    the download method to get apod content from apod server
    func apodDataDownload () async throws {
        
        
        let(apodStartingDate, apodEndingDate) = getDateInput()

        for date in stride(from: apodStartingDate, to: apodEndingDate, by: 1) {
        
            let eachDateComponent = "\(date.year)-\(date.month)-\(date.day)"
            let urlComponents = createUrl(eachDateComponent: eachDateComponent)
            print("ehats spsoskssjksksk")
            guard let url = URL(string: "\(urlComponents)") else { continue }
            print("sjdjddjmdjdjdjdndmnkdkdmkdmdmdkmdmdkdm")
            let apodDownloaded = try await dataData(url: url)
            print("ddjsn")
            let validApodDownloaded = await updateInterface(apod: apodDownloaded)
 
            DispatchQueue.main.async { [weak self] in
                self?.displaying = true
                self?.allApodContents.append(validApodDownloaded)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            
            withAnimation(.linear) {
                self?.state = .waiting
            }
        }
     
    }
    
//    the last method of the dynamic/refreshing request call to get the appropriate image from the corresponding apod data from the server
    
    func updateInterface (apod: ApodServer) async -> ApodServer {
        
        guard let apodImage = await fetchImage(with: apod.url) else { return apod }
        var validApod = apod
        validApod.image = apodImage
        return validApod
        
    }
    
  }
    
    
    

