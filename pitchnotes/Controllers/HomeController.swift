//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

struct IdeaDeck: Codable {
    var deck: [Idea]
    init(){
        self.deck = Array<Idea>()
    }
}

struct Idea: Codable {
    var id: String
    var name: String
    var category: String
    var description: String
    var owner: Owner
}

struct Owner: Codable {
    var id: String
    var name: String
    var photoURL: String
}

class HomeController: UIViewController {
    
    var ideaDeck = Array<IdeaCardView>()
    
    @IBOutlet weak var cardDeckView: UIView!
    
    @IBAction func likeButton(_ sender: Any) {
        if let card = getCurrentCard(){
            let cardIndex = ideaDeck.count-1
            card.swipeRight()
            ideaDeck.remove(at: cardIndex)
        }
    }
    
    @IBAction func dislikeButton(_ sender: Any) {
        if let card = getCurrentCard(){
            let cardIndex = ideaDeck.count-1
            card.swipeLeft()
            ideaDeck.remove(at: cardIndex)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getIdeaDeck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getCurrentCard() -> IdeaCardView? {
        if (self.ideaDeck.count > 0){
            return self.ideaDeck[self.ideaDeck.count-1]
        }
        else{
            return nil
        }
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
                            self.ideaDeck.append(cardView)
                        }
                    })
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
                }.resume()
        }
    }

}

