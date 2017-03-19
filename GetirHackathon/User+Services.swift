//
//  User+Services.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 19/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

extension User {
    
    typealias ElementResult = ([Shape]?, API.APIErrors?) -> Void
    
    func getElements(completion: @escaping ElementResult) {
        API.shared.fetch(.getElements(email: self.email, name: self.name, gsm: self.gsm)) { (json, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = json as? [String: Any] else {
                completion(nil, .parse)
                return
            }
            
            guard let elementsArray = rootJson["elements"] as? [Any] else {
                completion(nil, .incorrectData)
                return
            }
            
            var shapeList = [Shape]()
            
            for element in elementsArray {
                
                if let elementJson = element as? [String: Any] {
                    if let shape = Shape(from: elementJson) {
                        shapeList.append(shape)
                    }
                    
                }
            }
            
            completion(shapeList, nil)
        }
    }
    
    private func parseJsonIntoShape() -> Shape? {
        return nil
    }
}
