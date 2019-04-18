//
//  IdeaCardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/9/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
}
