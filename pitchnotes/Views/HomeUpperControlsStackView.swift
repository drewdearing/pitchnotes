//
//  HomeBottomControlsUIStackView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/7/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class HomeUpperControlsUIStackView: UIStackView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subviews = [UIColor.gray, .darkGray, .black].map{ (color) -> UIView in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        
        subviews.forEach { (subView) in
            addArrangedSubview(subView)
        }
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
