//
//  Groups.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import Foundation
import Firebase

struct MatchedGroups: Codable{
    let created: [MatchedIdeas]
    let joined: [MatchedIdeas]
}

struct MatchedIdeas: Codable {
    let id: String
    let name: String
    let memberCount: Int
}

class Groups{
    var baseAPI: String
    
    init() {
        self.baseAPI = BaseAPI.getBase() + "groups/"
    }
    
    func getGroups(completion: @escaping (MatchedGroups, Error?) -> Void){
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
            if let error = error{
                print("error getting idToken\(error)")
                completion(MatchedGroups(created: [], joined: []), error)
                return;
            }
            guard let idToken = idToken else {return}
            let urlPathBase = self.baseAPI
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "GET"
            request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
                guard let data = data else {
                    print("data issue when get matched groups")
                    return
                }
                do {
                    let matchedGroups = try JSONDecoder().decode(MatchedGroups.self, from: data)
                    print(matchedGroups)
                    completion(matchedGroups, nil)
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
            }.resume()
        })
    }
    
}
