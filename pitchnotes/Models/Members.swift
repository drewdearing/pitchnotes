//
//  File.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//
import Foundation
import FirebaseAuth

struct MembersInGroup: Codable {
    let members: [SingleMember]
}

struct SingleMember: Codable {
    let id: String
    let name: String
    let bio: String
}

class Members{
    var baseAPI: String
    var ideaID: String
    
    init(ideaID: String) {
        self.baseAPI = BaseAPI.getBase() + "members/"
        self.ideaID = ideaID
    }
    
    func getMembers(completion: @escaping (MembersInGroup, Error?) -> Void){
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("error getting idToken\(error)")
                completion(MembersInGroup(members: []), error)
                return;
            }
            guard let idToken = idToken else {return}
            let urlPathBase = self.baseAPI + self.ideaID
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "GET"
            request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
                guard let data = data else { return }
                do {
                    let membersInGroup = try JSONDecoder().decode(MembersInGroup.self, from: data)
                    print(membersInGroup.members)
                    completion(membersInGroup, nil)
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
            }.resume()
        }
    }
}
