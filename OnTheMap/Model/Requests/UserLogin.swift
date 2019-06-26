//
//  UserLogin.swift
//  OnTheMap
//
//  Created by Lukasz on 24/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

struct UserLogin: Codable {
    
    let udacity: Login
}

struct Login: Codable {
    let username: String
    let password: String
}
