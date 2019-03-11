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

struct CandidateDeck: Codable {
    var deck: [Candidate]
    init(){
        self.deck = Array<Candidate>()
    }
}

struct Idea: Codable {
    var id: String
    var name: String
    var category: String
    var description: String
    var owner: IdeaOwner
}

struct Candidate: Codable {
    var id: String
    var name: String
    var photoURL: String
    var skills: [String]
    var bio: String
    var idea: CandidateIdea
}

struct IdeaOwner: Codable {
    var id: String
    var name: String
    var photoURL: String
}

struct CandidateIdea: Codable {
    var id: String
    var name: String
}

class HomeController: UIViewController {
    
    var cardDeck = Array<CardView>()
    var ideasCurrentDeck = true
    @IBOutlet weak var switchButton: UIButton!
    
    @IBOutlet weak var cardDeckView: UIView!
    
    @IBAction func switchDecks(_ sender: Any) {
        if(ideasCurrentDeck){
            getProfileDeck()
            switchButton.setImage(#imageLiteral(resourceName: "candidates_top"), for: .normal)
        }
        else{
            getIdeaDeck()
            switchButton.setImage(#imageLiteral(resourceName: "idea_top"), for: .normal)
        }
    }
    
    @IBAction func likeButton(_ sender: Any) {
        if let card = getCurrentCard(){
            let cardIndex = cardDeck.count-1
            card.swipeRight()
            cardDeck.remove(at: cardIndex)
        }
    }
    
    @IBAction func dislikeButton(_ sender: Any) {
        if let card = getCurrentCard(){
            let cardIndex = cardDeck.count-1
            card.swipeLeft()
            cardDeck.remove(at: cardIndex)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getIdeaDeck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getCurrentCard() -> CardView? {
        if (self.cardDeck.count > 0){
            return self.cardDeck[self.cardDeck.count-1]
        }
        else{
            return nil
        }
    }
    
    func clearDeck(){
        for view in cardDeckView.subviews {
            view.removeFromSuperview()
        }
        cardDeck = Array<CardView>()
    }
    
    func getIdeaDeck() {
        clearDeck()
        ideasCurrentDeck = true
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
                            cardView.ideaUid = idea.id
                            cardView.userUid = currentUser!.uid
                            cardView.cardUserName.text = idea.owner.name
                            cardView.cardTitle.text = idea.name
                            cardView.cardDesc.text = idea.description
                            cardView.cardCategory.text = idea.category
                            let url = URL(string: idea.owner.photoURL)
                            let data = try? Data(contentsOf: url!)
                            if let imageData = data {
                                cardView.cardProfilePic.image = UIImage(data:imageData)
                                cardView.cardIdeaPic.image = UIImage(data:imageData)
                            }
                            self.cardDeckView.addSubview(cardView)
                            cardView.fillSuperview()
                            self.cardDeck.append(cardView)
                        }
                    })
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
                }.resume()
        }
    }
    
    func getProfileDeck(){
        clearDeck()
        ideasCurrentDeck = false
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                // Handle error
                return;
            }
            
            print("Bearer "+idToken!)
            let urlPathBase = "https://us-central1-pitchnote-f1fd4.cloudfunctions.net/candidatesDeck/"
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "GET"
            request.addValue("Bearer "+idToken!, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
                guard let data = data else { return }
                do {
                    print(String(data: data, encoding: String.Encoding.utf8))
                    let candidatesDeck = try JSONDecoder().decode(CandidateDeck.self, from: data)
                    candidatesDeck.deck.forEach({ (candidate) in
                        DispatchQueue.main.async {
                            let cardView = ProfileCardView()
                            cardView.ideaUid = candidate.idea.id
                            cardView.userUid = candidate.id
                            cardView.cardUserName.text = candidate.name
                            cardView.cardIdeaName.text = candidate.idea.name
                            cardView.cardUserBio.text = candidate.bio
                            cardView.cardClassYear.text = "class of...."
                            let url = URL(string: candidate.photoURL)
                            let data = try? Data(contentsOf: url!)
                            if let imageData = data {
                                cardView.cardProfilePic.image = UIImage(data:imageData)
                                cardView.cardIdeaPic.image = UIImage(data:imageData)
                            }
                            self.cardDeckView.addSubview(cardView)
                            cardView.fillSuperview()
                            self.cardDeck.append(cardView)
                        }
                    })
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
                }.resume()
        }
    }

}

