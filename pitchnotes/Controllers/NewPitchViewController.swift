//
//  NewPitchViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 4/3/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class NewPitchViewController: UIViewController, UINavigationBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
