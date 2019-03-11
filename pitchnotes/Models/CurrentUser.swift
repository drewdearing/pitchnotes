//
//  File.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import Foundation
import Firebase

class CurrentUser {
    var currentUser: User
    var myToken: String
    init() {
        currentUser = Auth.auth().currentUser!
        myToken = ""
    }
    
    func getIdToken() {
        
        currentUser.getIDTokenForcingRefresh(true) { (idToken, error) in
            if let error = error {
                print(error)
                return;
            }
            guard let idToken = idToken else {return}
            self.myToken = idToken
        }
    }
    
}
