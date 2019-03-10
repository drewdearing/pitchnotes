//
//  IdeaCardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/9/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class IdeaCardView: UIView {

    let swipeOverlay = UIView()
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardIdeaPic: UIImageView!
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
        
        //swipe gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    func swipeRight(){
        let x = self.superview!.frame.width/2
        let degrees = x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = rotationalTransform.translatedBy(x: x, y: 0)
            self.layer.opacity = 0
            self.swipeOverlay.backgroundColor = .green
            self.swipeOverlay.layer.opacity = 1.0
            
        }, completion:{ (bool) in
            self.removeFromSuperview()
        })
    }
    
    func swipeLeft(){
        let x = -self.superview!.frame.width/2
        let degrees = x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = rotationalTransform.translatedBy(x: x, y: 0)
            self.layer.opacity = 0
            self.swipeOverlay.backgroundColor = .red
            self.swipeOverlay.layer.opacity = 1.0
        }, completion:{ (bool) in
            self.removeFromSuperview()
        })
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            handleGestureChange(gesture)
        case .ended:
            handleGestureEnd(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleGestureEnd(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let shouldDismiss = abs(translation.x) > (self.superview!.frame.width/2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if(shouldDismiss){
                self.layer.opacity = 0
                self.removeFromSuperview()
            }
            else{
                self.layer.opacity = 1
                self.transform = .identity
                self.swipeOverlay.layer.opacity = 0
                self.swipeOverlay.backgroundColor = .white
            }
        })
    }
    
    fileprivate func handleGestureChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
        self.layer.opacity = Float(1-(abs(translation.x)/(self.superview!.frame.width/2)))
        if(translation.x > 0){
            swipeOverlay.backgroundColor = .green
        }
        else if(translation.x < 0){
            swipeOverlay.backgroundColor = .red
        }
        else {
            swipeOverlay.backgroundColor = .white
        }
        
        swipeOverlay.layer.opacity = 1.0-self.layer.opacity
    }

}
