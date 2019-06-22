//
//  APIRequest.swift
//  OnTheMap
//
//  Created by Lukasz on 21/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

class APIRequest{
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
        
    }
    
    
    class func getStudentsLocation(completionHandler: @escaping ([StudentLocation]?, Error?) -> Void) {
        
        guard let url = URL(string: Endpoints.base) else {
            return
        }
      
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
        }
            let decoder = JSONDecoder()
            do {
                let requestObject = try decoder.decode(Results.self, from: data)
                completionHandler(requestObject.results, nil)
                
            } catch {
                completionHandler([], error)
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

