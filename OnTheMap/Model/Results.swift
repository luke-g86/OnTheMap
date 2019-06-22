//
//  Results.swift
//  OnTheMap
//
//  Created by Lukasz on 21/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct Results: Codable {
    
    let results: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
