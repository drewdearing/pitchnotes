//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

let topStackView = HomeUpperControlsUIStackView()
let cardsDeckView = UIView()
let bottomView = HomeBottomControlsUIStackView()
let hamburgerView = UIView()

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

struct User: Decodable {
    let name: String
}

class HomeController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        getIdeaDeck()
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
                            let cardView = CardView()
                            cardView.cardNameLabel.text = idea.owner.name
                            cardView.cardTitleLabel.text = idea.name
                            cardView.cardDescLabel.text = idea.description
                            cardsDeckView.addSubview(cardView)
                            cardView.fillSuperview()
                        }
                    })
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
                }.resume()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupHamburgerView()
    }
    
    fileprivate func setupHamburgerView(){
        
    }
    
    fileprivate func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomView])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        stackView.bringSubviewToFront(cardsDeckView)
    }

}

