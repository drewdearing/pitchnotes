//
//  IdeaCardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/9/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFunctions
import SVProgressHUD

class ProfileCardView: CardView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardUserName: UILabel!
    @IBOutlet weak var cardIdeaName: UILabel!
    @IBOutlet weak var cardUserBio: UILabel!
    @IBOutlet weak var cardProfilePic: UIImageView!
    @IBOutlet weak var cardIdeaPic: UIImageView!
    @IBOutlet weak var cardClassYear: UILabel!
    @IBOutlet weak var skillLabel1: UILabel!
    @IBOutlet weak var skillLabel2: UILabel!
    @IBOutlet weak var skillLabel3: UILabel!
    weak var parentView: HomeController!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.isUser = true
        Bundle.main.loadNibNamed("ProfileCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.fillSuperview()
        
        //round corners
        layer.cornerRadius = 10
        clipsToBounds = true
        
        //border
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        //set profile pic style
        cardProfilePic.layer.cornerRadius = cardProfilePic.frame.height/2
        cardProfilePic.layer.borderWidth = 10
        cardProfilePic.layer.borderColor = UIColor.white.cgColor
        cardProfilePic.clipsToBounds = true
        
        //swipe color overlay
        swipeOverlay.backgroundColor = .white
        swipeOverlay.layer.opacity = 0
        addSubview(swipeOverlay)
        swipeOverlay.fillSuperview()
    }
    
    @IBAction func onReportPressed(_ sender: Any) {
        var functions = Functions.functions()
        let alert = UIAlertController(title: "Report", message: "Do you want to report this candidate for inappropriate content?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                functions.httpsCallable("report").call(["id": self.cardIdeaName.text]) { (result, error) in
                    if let error = error as NSError? {
                        if error.domain == FunctionsErrorDomain {
                            let code = FunctionsErrorCode(rawValue: error.code)
                            let message = error.localizedDescription
                            let details = error.userInfo[FunctionsErrorDetailsKey]
                        }
                    }
                }
                SVProgressHUD.showSuccess(withStatus: "Candidate was reported!")
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        parentView.present(alert, animated: true, completion: nil)
    }
    
    
}
