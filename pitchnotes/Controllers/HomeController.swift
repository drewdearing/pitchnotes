//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import TTSegmentedControl

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
    var graduate: Int
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
    var pinnedDeck = false
    var currentTask:URLSessionDataTask?
    
    @IBOutlet weak var cardDeckView: UIView!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    func switchDecks(index: Int) {
        pinnedDeck = false
        setPinImage()
        if index == 0{
            getIdeaDeck()
            ideasCurrentDeck = true
        }else{
            getProfileDeck()
            ideasCurrentDeck = false
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
    
    @IBAction func pinButton(_ sender: Any) {
        if let card = getCurrentCard(){
            let cardIndex = cardDeck.count-1
            card.swipeUp()
            cardDeck.remove(at: cardIndex)
        }
    }
    
    @IBAction func togglePinDecks(_ sender: Any) {
        pinnedDeck = !pinnedDeck
        setPinImage()
        if pinnedDeck {
            pinButton.imageView!.tintColor = .blue
        }
        else{
            pinButton.imageView!.tintColor = nil
        }
        if(ideasCurrentDeck){
            getIdeaDeck()
        }
        else{
            getProfileDeck()
        }
    }
    
    func setPinImage(){
        if pinnedDeck {
            pinButton.setImage(#imageLiteral(resourceName: "top_right_pin_enabled2"), for: .normal)
        }
        else{
            pinButton.setImage(#imageLiteral(resourceName: "top_right_pin"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setPinImage()
        if(ideasCurrentDeck){
            getIdeaDeck()
        }
        else{
            getProfileDeck()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add segmented control to the view
        let segmentedControl = TTSegmentedControl()
        segmentedControl.itemTitles = ["1", "2"]
        segmentedControl.allowChangeThumbWidth = false
        
        segmentedControl.frame = CGRect(x: 50, y: 50, width: 80, height: 40)
        
        segmentedControl.didSelectItemWith = { (index, title) -> () in
            self.switchDecks(index: index)
        }
        
        view.addSubview(segmentedControl)
//
//        let imageAttachment = NSTextAttachment()
//        imageAttachment.image = UIImage(named:"idea_deck")
//        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
//
//        let attributes = NSAttributedString(attachment: imageAttachment)
//
//        segmentedControl.changeAttributedTitle(attributes, selectedTile: attributes, atIndex: 0)
        
        //replace title with image.
        segmentedControl.layoutSubviews()
        let imageAttachment0 = NSTextAttachment()
        imageAttachment0.image = UIImage(named:"idea_deck")
        imageAttachment0.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        
        let attributes0 = NSAttributedString(attachment: imageAttachment0)
        
        segmentedControl.changeAttributedTitle(attributes0, selectedTile: attributes0, atIndex: 0)
        
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(named:"matched-groups")
        imageAttachment1.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        let attributes1 = NSAttributedString(attachment: imageAttachment1)
        segmentedControl.changeAttributedTitle(attributes1, selectedTile: attributes1, atIndex: 1)
        
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)

        let widthConstraint = NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: segmentedControl, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
        view.addConstraints([horizontalConstraint, widthConstraint, heightConstraint])
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20)
            ])
        
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
    
    func setCurrentTask(task: URLSessionDataTask){
        if let current = currentTask {
            current.cancel()
            currentTask = nil
            clearDeck()
            SVProgressHUD.dismiss()
        }
        currentTask = task
        currentTask?.resume()
        SVProgressHUD.show(withStatus: "Loading...")
    }
    
    func getIdeaDeck() {
        statusLabel.isHidden = true
        clearDeck()
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                // Handle error
                return;
            }
            
            print("Bearer "+idToken!)
            var deckType = "ideaDeck"
            if self.pinnedDeck {
                deckType = "pinnedIdeas"
            }
            let urlPathBase = "https://us-central1-pitchnote-f1fd4.cloudfunctions.net/"+deckType+"/"
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "GET"
            request.addValue("Bearer "+idToken!, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
                SVProgressHUD.dismiss()
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
                    print(ideaDeck.deck.count)
                    if ideaDeck.deck.count <= 0 {
                        DispatchQueue.main.async {
                            self.statusLabel.isHidden = false
                            if self.pinnedDeck {
                                self.statusLabel.text = "No Pinned Ideas!"
                            }
                            else{
                                self.statusLabel.text = "No New Ideas Yet!"
                            }
                        }
                    }
                    
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
            }
            self.setCurrentTask(task:task)
        }
    }
    
    func getProfileDeck(){
        statusLabel.isHidden = true
        clearDeck()
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                // Handle error
                return;
            }
            print("Bearer "+idToken!)
            var deckType = "candidatesDeck"
            if self.pinnedDeck {
                deckType = "pinnedCandidates"
            }
            let urlPathBase = "https://us-central1-pitchnote-f1fd4.cloudfunctions.net/"+deckType+"/"
            let request = NSMutableURLRequest()
            request.url = URL(string: urlPathBase)
            request.httpMethod = "GET"
            request.addValue("Bearer "+idToken!, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, err) in
                SVProgressHUD.dismiss()
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
                            cardView.cardClassYear.text = "Class of "+String(candidate.graduate)
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
                    if candidatesDeck.deck.count <= 0 {
                        DispatchQueue.main.async {
                            self.statusLabel.isHidden = false
                            if self.pinnedDeck {
                                self.statusLabel.text = "No Pinned Candidates!"
                            }
                            else{
                                self.statusLabel.text = "No Candidates Yet!"
                            }
                        }
                    }
                } catch let jsonErr {
                    print("Error: \(jsonErr)")
                }
            }
            self.setCurrentTask(task:task)
        }
    }
    @IBAction func sideBarPressed(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
}

