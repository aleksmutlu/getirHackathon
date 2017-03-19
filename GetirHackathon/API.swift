//
//  API.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 19/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

fileprivate let kEmail = "email"
fileprivate let kName = "name"
fileprivate let kGsm = "gsm"

// MARK: - Initialization & Properties
class API: NSObject {
    
    static var shared = API()
    override private init() {
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    static let baseURL = "https://getir-bitaksi-hackathon.herokuapp.com"
    
    typealias RequestResult = (Any?, APIErrors?) -> Void
    
    fileprivate var session: URLSession!
    
}

// MARK: - Enums
extension API {
    
    enum Endpoints {
        
        case getElements(email: String, name: String, gsm: String)
        
        var method: String {
            switch self {
            case .getElements: return Methods.post.rawValue
            }
        }
        
        var path: String {
            switch self {
            case .getElements: return "/getElements"
            }
        }
        
        var parameters: [String: Any] {
            var parameters = [String: Any]()
            
            switch self {
            case .getElements(let email, let name, let gsm):
                parameters[kEmail] = email
                parameters[kName] = name
                parameters[kGsm] = gsm
            }
            
            return parameters
        }
        
        var parametersToCheck: [String: String] {
            var parameters = [String: String]()
            
            switch self {
            case .getElements:
                parameters["msg"] = "success"
            }
            
            return parameters
        }
    }
    
    enum Methods: String {
        
        case get = "GET"
        case post = "POST"
        
    }
    
    enum APIErrors: String, Error {
        case badURL = "Can't create the url"
        case client = "Problem occured while establishing connection..."
        case server = "Problem occured on the server"
        case parse = "JSON parsing error"
        case parameterCheckFailed = "Parameter check failed"
        case incorrectData = "Data format is not correct"
    }
    
}

// MARK: - Functions
extension API {
    
    func fetch(_ endpoint: Endpoints, completion: @escaping RequestResult) {
        
        guard let url = self.url(for: endpoint) else {
            completion(nil, .badURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: .init(rawValue: 0))
        self.session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, .client)
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                completion(nil, .server)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options:[]) else {
                completion(nil, .parse)
                return
            }
            
            guard let rootJson = json as? [String: Any] else {
                completion(nil, .parse)
                return
            }
            
            for param in endpoint.parametersToCheck {
                guard let p = rootJson[param.key] as? String, p.lowercased() == param.value else {
                    completion(nil, .parameterCheckFailed)
                    return
                }
            }
            
            completion(json, nil)
            
        }.resume()
        
    }
    
    fileprivate func url(for endpoint: API.Endpoints) -> URL? {
        var urlComponent = URLComponents(string: API.baseURL)
        urlComponent!.path = endpoint.path
        return urlComponent?.url
    }
    
}
