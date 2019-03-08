//
//  CardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/7/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let image = UIImageView(image: #imageLiteral(resourceName: "40279285_10216911105591153_8570435745418838016_n (1)"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(image)
        image.fillSuperview()
        image.contentMode = .scaleAspectFill
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            handleGestureChange(gesture)
        case .ended:
            handleGestureEnd()
        default:
            ()
        }
    }
    
    fileprivate func handleGestureEnd() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {self.transform = .identity})
    }
    
    fileprivate func handleGestureChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
