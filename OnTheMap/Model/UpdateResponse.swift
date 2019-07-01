//
//  UpdateResponse.swift
//  OnTheMap
//
//  Created by Lukasz on 28/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct UpdateResponse: Codable {
    
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt
    }
}
