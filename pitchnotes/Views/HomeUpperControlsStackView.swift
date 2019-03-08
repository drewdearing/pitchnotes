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
        
        let buttonViews = [#imageLiteral(resourceName: "top_left_ham"),#imageLiteral(resourceName: "idea_top"), #imageLiteral(resourceName: "top_right_pin")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        addArrangedSubview(buttonViews[0])
        addArrangedSubview(UIView())
        addArrangedSubview(buttonViews[1])
        addArrangedSubview(UIView())
        addArrangedSubview(buttonViews[2])
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        distribution = .equalCentering
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
