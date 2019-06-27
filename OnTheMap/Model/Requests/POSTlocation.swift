//
//  POSTlocation.swift
//  OnTheMap
//
//  Created by Lukasz on 26/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct PostLocation: Codable {
    
    var key: String
    var firstName: String
    var lastName: String
    var city: String
    var mediaURL: String
    var latitude: String
    var longitude: String
    
    enum CodingKeys: String, CodingKey {
        case key = "uniqueKey"
        case firstName
        case lastName
        case city = "mapString"
        case mediaURL
        case latitude
        case longitude
    }
    
    init(key: String, firstName: String, lastName: String, city: String, mediaURL: String, latitude: String, longitude: String) {
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
