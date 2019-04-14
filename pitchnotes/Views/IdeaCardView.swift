//
//  IdeaCardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/9/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

class IdeaCardView: CardView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardColorView: UIView!
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var cardProfilePic: UIImageView!
    @IBOutlet weak var cardUserName: UILabel!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardCategory: UILabel!
    @IBOutlet weak var cardDesc: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.isUser = false
        Bundle.main.loadNibNamed("IdeaCard", owner: self, options: nil)
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
