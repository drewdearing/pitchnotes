//
//  CardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/7/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

let swipeOverlay = UIView()

class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        setupCard()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupCard(){
        let imageView = UIImageView(image: #imageLiteral(resourceName: "40279285_10216911105591153_8570435745418838016_n (1)"))
        imageView.contentMode = .scaleAspectFill
        let ideaOverlay = UIView()
        ideaOverlay.backgroundColor = .black
        ideaOverlay.layer.opacity = 0.2
        imageView.addSubview(ideaOverlay)
        ideaOverlay.fillSuperview()
        let cardBottomView = UIView()
        cardBottomView.backgroundColor = .white
        cardBottomView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        let InformationLabel = UILabel()
        cardBottomView.addSubview(InformationLabel)
        InformationLabel.text = "Drew"
        InformationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        InformationLabel.anchor(top: cardBottomView.topAnchor, leading: nil, bottom: nil, trailing: nil)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, cardBottomView])
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
                swipeOverlay.layer.opacity = 0
                swipeOverlay.backgroundColor = .white
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
