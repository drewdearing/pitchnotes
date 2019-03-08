//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

let topStackView = HomeUpperControlsUIStackView()
let cardsDeckView = UIView()
let bottomView = HomeBottomControlsUIStackView()

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCards()
    }
    
    fileprivate func setupCards() {
        (0..<10).forEach { (_) in
            let cardView = CardView()
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomView])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        stackView.bringSubviewToFront(cardsDeckView)
    }

}

