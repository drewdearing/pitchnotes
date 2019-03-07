//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topStackView = HomeUpperControlsUIStackView()
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let bottomView = HomeBottomControlsUIStackView()

        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomView])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }


}

