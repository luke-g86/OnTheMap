//
//  APIRequest.swift
//  OnTheMap
//
//  Created by Lukasz on 21/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

class APIRequests{
    
    static let udacityLogin = UserLogin(udacity: Login(username: "gajewski.lukasz@hotmail.com", password: "CWFe5T9Hs6B"))
    
    struct Auth {
        static var keyAccount = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        
        case establishSession
        case getStudentsLocation
        case postStudentLocation
        case getUserData
        
        var urlBody: String {
            switch self {
            case .establishSession: return Endpoints.base + "session"
            case .getStudentsLocation: return Endpoints.base + "StudentLocation?order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .getUserData: return Endpoints.base + "users/" + Auth.keyAccount
            }
        }
        
        var url: URL {
            return URL(string: urlBody)!
        }
    }
    
    class func login(username: String, password: String, completionHandler: @escaping(Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.establishSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = UserLogin(udacity: Login(username: username, password: password))
        
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completionHandler(false, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(UserLoginResponse.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseObject.session.id
                    self.Auth.keyAccount = responseObject.account.key
                    completionHandler(true, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
        }
        
        task.resume()
    }
    
    
    class func getStudentsLocation(completionHandler: @escaping ([StudentLocation]?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: Endpoints.getStudentsLocation.url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let requestObject = try decoder.decode(Results.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(requestObject.results, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completionHandler([], error)
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    class func getUserData(completionHandler: @escaping (UserData?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getUserData.url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let requestObject = try decoder.decode(UserData.self, from: newData)
                DispatchQueue.main.async {
                    print(newData)
                    completionHandler(requestObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            
        }
        task.resume()
    }
    
    class func postStudentLocation(userGatheredData: PostLocation, completionHandler: @escaping (PostResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(userGatheredData)
        
        let body = PostLocation(uniqueKey: StorageController.user.uniqueKey, firstName: StorageController.user.firstName, lastName: StorageController.user.lastName, mapString: StorageController.user.mapString, mediaURL: StorageController.user.mediaURL, latitude: StorageController.user.latitude, longitude: StorageController.user.longitude)

        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completionHandler(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
}



