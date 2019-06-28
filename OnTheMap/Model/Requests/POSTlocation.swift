//
//  POSTlocation.swift
//  OnTheMap
//
//  Created by Lukasz on 26/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct PostLocation: Codable {
    
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
    }
    
    init(
        uniqueKey: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        mapString: String? = nil,
        mediaURL: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
        )
    {
        self.uniqueKey = uniqueKey ?? "nil"
        self.firstName = firstName ?? "nil"
        self.lastName = lastName ?? "nil"
        self.mapString = mapString ?? "nil"
        self.mediaURL = mediaURL ?? "nil"
        self.latitude = latitude ?? 0
        self.longitude = longitude ?? 0
        
    }
}

