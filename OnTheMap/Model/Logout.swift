//
//  Logout.swift
//  OnTheMap
//
//  Created by Lukasz on 29/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct SessionLogout: Codable {
    
    let session: Logout
    
}

struct Logout: Codable {
    
    let sessionId: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiration
        
    }
}

