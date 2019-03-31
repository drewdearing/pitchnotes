//
//  TempViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/30/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import SideMenuSwift

class TempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didclickedMenu(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
