//
//  HomeBottomControlsUIStackView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/7/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class HomeBottomControlsUIStackView: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button = UIButton(type: .system)
        
        let bottomSubViews = [UIColor.red, .green, .blue, .yellow, .purple].map { (color) -> UIView in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        
        bottomSubViews.forEach { (subView) in
            addArrangedSubview(subView)
        }
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
