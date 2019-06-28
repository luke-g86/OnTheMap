//
//  POSTresponse.swift
//  OnTheMap
//
//  Created by Lukasz on 28/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct PostResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
