//
//  Apod Models.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//


import Foundation
import UIKit



class ApodModel: ObservableObject, Hashable, Identifiable {
    static func == (lhs: ApodModel, rhs: ApodModel) -> Bool {
        lhs.url == rhs.url
    }
    
    let id = UUID()
    var title:String
    var url: URL
    var description: String
    var date:String
    var image: UIImage?
    var defaultImage = UIImage(systemName: "photo.on.rectangle")!
    
    init(title:String, url: URL, description: String, date:String, image: UIImage?){
        self.title = title
        self.url = url
        self.description = description
        self.date = date
        self.image = image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}





enum PhotoInfoError : Error, LocalizedError {
    
    case imageDataMissing
}



struct ApodServer: Encodable, Decodable {
    
    let id = UUID()
    var title: String
    var description: String
    var url: URL
    var image: UIImage?
    var date: String
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case description = "explanation"
        case url
        case date
    }
    
    init(from decoder: Decoder) throws {
        
       let decoder = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try decoder.decode(String.self, forKey: .title)
        self.description = try decoder.decode(String.self, forKey: .description)
        self.url = try decoder.decode(URL.self, forKey: .url)
        self.date = try decoder.decode(String.self, forKey: .date)
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        
        try encoder.encode(title, forKey: .title)
        try encoder.encode(description, forKey: .description)
        try encoder.encode(url, forKey: .url)
        try encoder.encode(date, forKey: .date)
        
    }
}




struct ProgramDate: Equatable {
    var year: Int
    var month: Int
    var day: Int
    
}


