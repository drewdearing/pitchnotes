//
//  NewPitch.swift
//  pitchnotes
//
//  Created by Xi Jin on 4/3/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import Foundation

import Firebase

struct MyNewPitch: Codable{
    let name: String
    let description: String
    let category: String
    let hue: Float
}

enum CreatePitchError: Error {
    case unableToEncode
    case cannotFindCreatedPitch
}

extension CreatePitchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToEncode:
            return NSLocalizedString("Unable to encode", comment: "Unable to encode")
        case .cannotFindCreatedPitch:
            return NSLocalizedString("Cannot find created pitch", comment: "Cannot find created pitch")
        }
    }
}

class NewPitch{
    var baseAPI: String
    
    init() {
        self.baseAPI = BaseAPI.getBase() + "idea/"
    }
    
    func postNewPitch(completion: @escaping (MyNewPitch, Error?) -> Void, myNewPitch: MyNewPitch) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
            if let error = error {
                print("error getting idToken\(error)")
                completion(myNewPitch, error)
                return
            }
            guard let idToken = idToken else {return}
            let urlPathBase = self.baseAPI
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "POST"
            request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            guard let uploadData = try? JSONEncoder().encode(myNewPitch) else {
                return
            }
            print(uploadData)
            
            let task = URLSession.shared.uploadTask(with: request as URLRequest, from: uploadData) { data, response, error in
                if let error = error {
                    print ("error: \(error)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        return
                }
                completion(myNewPitch, nil)
                if let mimeType = response.mimeType,
                    mimeType == "application/json",
                    let data = data,
                    let dataString = String(data: data, encoding: .utf8) {
                    print ("got data: \(dataString)")
                }
            }
            task.resume()
        })
    }
}
