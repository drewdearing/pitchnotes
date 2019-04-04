//
//  ProfileViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 4/4/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = getCurrentProfile() {
            nameLabel.text = profile.name + ", Class of " + String(profile.graduate)
            emailLabel.text = profile.schoolEmail
            bioLabel.text = profile.bio
            skillsLabel.text = profile.skills.joined(separator: ", ")
            
            let url = URL(string: profile.photoURL)
            let data = try? Data(contentsOf: url!)
            if let imgData = data {
                let image = UIImage(data:imgData)
                imageView.image = image
            }
        }
    }
    
    @IBAction func sideButton(_ sender: Any) {
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
