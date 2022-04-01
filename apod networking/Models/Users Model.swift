//
//  Users Model.swift
//  apod networking
//
//  Created by Olusehinde Samson on 3/25/22.
//

import Foundation
import CoreData


class registeringUser {
    
     static let model = registeringUser()
    
     var firstName = ""
     var lastName = ""
     var userName = ""
     var emailAddress = ""
     var password = ""
     var confirmPassword = ""
    
}






extension CodingUserInfoKey {
    
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
    
  
}

enum DecoderConfigurationError: Error {
    
    case missingManagedObjectContext
    
}






public class UsersEntity: NSManagedObject, Encodable, Decodable {
    
    enum CodingKeys: CodingKey {
        
        case userName
        case firstName
        case lastName
        case emailAddress
        case password
    }
    
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(userName, forKey: .userName)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(emailAddress, forKey: .emailAddress)
        try container.encode(password, forKey: .password)
    }
    
    
    required convenience public init(from decoder: Decoder) throws {
        
        
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else  {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userName = try container.decode(String.self, forKey: .userName)
        self.password = try container.decode(String.self, forKey: .password)
        self.emailAddress = try container.decode(String.self, forKey: .emailAddress)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
    
    
}

