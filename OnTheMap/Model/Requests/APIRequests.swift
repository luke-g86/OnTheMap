//
//  APIRequest.swift
//  OnTheMap
//
//  Created by Lukasz on 21/06/2019.
//  Copyright © 2019 Lukasz. All rights reserved.
//

import Foundation

class APIRequests{
    
//    static let udacityLogin = UserLogin(udacity: Login(username: "gajewski.lukasz@hotmail.com", password: "CWFe5T9Hs6B"))
    
    struct Auth {
        static var keyAccount = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        
        case establishSession
        case getStudentsLocation
        case postStudentLocation
        case updateStudentLocation (String)
        case getUserData
        case logout
        
        var urlBody: String {
            switch self {
            case .establishSession: return Endpoints.base + "session"
            case .getStudentsLocation: return Endpoints.base + "StudentLocation?order=-updatedAt?limit=100"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .updateStudentLocation(let objectID): return Endpoints.base + "StudentLocation/\(objectID)"
            case .getUserData: return Endpoints.base + "users/" + Auth.keyAccount
            case .logout: return Endpoints.base + "session"
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
            print("login: \(String(data: data, encoding: .utf8))")
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
        
        let body = userGatheredData
        
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
                    print("true")
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
    
    
    class func updateStudentLocation(objectID: String, userGatheredData: PostLocation, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.updateStudentLocation(objectID).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = userGatheredData
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    return completionHandler(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(UpdateResponse.self, from: data)
                DispatchQueue.main.async {
                    print("update response : \(String(describing: responseObject))")
                    completionHandler(true, nil)
                    print("true")
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
    
    class func logout(completionHandler: @escaping(Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.logout.url)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
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
                
               let responseObject = try decoder.decode(SessionLogout.self, from: newData)
                DispatchQueue.main.async {

                    print(String(describing: responseObject.self))
                    self.Auth.sessionId = ""
                    self.Auth.keyAccount = ""
                    completionHandler(true, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    class func logoutByUdacity() {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(SessionLogout.self, from: newData!)
           
                    print("update response : \(String(describing: responseObject))")
                print(responseObject)
                    print("logout")
                }
            
            catch {
                print(error)
                }
            }
        
        task.resume()
    }
}



