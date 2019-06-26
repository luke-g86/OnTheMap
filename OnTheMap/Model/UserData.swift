//
//  UserData.swift
//  OnTheMap
//
//  Created by Lukasz on 26/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct UserData: Codable {
    
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
