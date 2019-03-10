//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

struct IdeaDeck: Decodable {
    let deck: [Idea]
}

struct Idea: Decodable {
    let id: String
    let name: String
    let category: String
    let description: String
    let owner: Owner
}

struct Owner: Decodable {
    let id: String
    let name: String
    let photoURL: String
}

class HomeController: UIViewController {
    
    
    @IBOutlet weak var cardDeckView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        getIdeaDeck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getIdeaDeck() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                // Handle error
                return;
            }
            
            print("Bearer "+idToken!)
            let urlPathBase = "https://us-central1-pitchnote-f1fd4.cloudfunctions.net/ideaDeck/"
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "GET"
            request.addValue("Bearer "+idToken!, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
                guard let data = data else { return }
                do {
                    print(String(data: data, encoding: String.Encoding.utf8))
                    let ideaDeck = try JSONDecoder().decode(IdeaDeck.self, from: data)
                    ideaDeck.deck.forEach({ (idea) in
                        DispatchQueue.main.async {
                            let cardView = IdeaCardView()
                            cardView.cardUserName.text = idea.owner.name
                            cardView.cardTitle.text = idea.name
                            cardView.cardDesc.text = idea.description
                            cardView.cardCategory.text = idea.category
                            let url = URL(string: idea.owner.photoURL)
                            let data = try? Data(contentsOf: url!)
                            if let imageData = data {
                                cardView.cardProfilePic.image = UIImage(data:imageData)
                            }
                            self.cardDeckView.addSubview(cardView)
                            cardView.fillSuperview()
                        }
                    })
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
                }.resume()
        }
    }

}

