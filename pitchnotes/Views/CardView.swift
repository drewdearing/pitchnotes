//
//  CardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/7/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    let swipeOverlay = UIView()
    let cardImageView = UIImageView(image: #imageLiteral(resourceName: "40279285_10216911105591153_8570435745418838016_n (1)"))
    let cardNameLabel = UILabel()
    let cardTitleLabel = UILabel()
    let cardDescLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        setupCard()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupCard(){
        cardImageView.contentMode = .scaleAspectFill
        //cardImageView.backgroundColor = .yellow
        let ideaOverlay = UIView()
        ideaOverlay.backgroundColor = .black
        ideaOverlay.layer.opacity = 0.3
        cardImageView.addSubview(ideaOverlay)
        ideaOverlay.fillSuperview()
        
        
        let cardBottomView = UIView()
        cardBottomView.backgroundColor = .white
        cardBottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        cardBottomView.addSubview(cardDescLabel)
        cardDescLabel.textColor = .black
        cardDescLabel.font = UIFont(name:"Helvetica", size:18)
        cardDescLabel.anchor(top: cardBottomView.topAnchor, leading: cardBottomView.leadingAnchor, bottom: nil, trailing: cardBottomView.trailingAnchor)
        
        cardImageView.addSubview(cardNameLabel)
        cardNameLabel.textColor = .white
        cardNameLabel.font = UIFont(name:"Helvetica-Bold", size:30)
        cardNameLabel.anchor(top: nil, leading: cardImageView.leadingAnchor, bottom: cardImageView.bottomAnchor, trailing: cardImageView.trailingAnchor)
        
        cardImageView.addSubview(cardTitleLabel)
        cardTitleLabel.fillSuperview()
        cardTitleLabel.textColor = .white
        cardTitleLabel.font = UIFont(name:"Helvetica-Bold", size:60)
        cardTitleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [cardImageView, cardBottomView])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.fillSuperview()
        layer.masksToBounds = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        swipeOverlay.backgroundColor = .white
        swipeOverlay.layer.opacity = 0
        stackView.addSubview(swipeOverlay)
        swipeOverlay.fillSuperview()
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
