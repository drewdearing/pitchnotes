//
//  File.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//
import Foundation
import FirebaseAuth

class Members{
    var baseAPI: String
    
    init(ideaID: String) {
        baseAPI = BaseAPI.getBase() + "members/"
    }
    
    func getMembers(ideaID: String) -> String{
        let urlPathBase = baseAPI + ideaID
        

        let request = NSMutableURLRequest()
        request.url = URL(string: urlPathBase)
        request.httpMethod = "GET"
        request.addValue("Bearer", forHTTPHeaderField: "Authorization")
        return "members"
    }
}
