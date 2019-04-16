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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gradyearLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var skill1Label: UILabel!
    @IBOutlet weak var skill2Label: UILabel!
    @IBOutlet weak var skill3Label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = getCurrentProfile() {
            let url = URL(string: profile.photoURL)
            let data = try? Data(contentsOf: url!)
            if let imgData = data {
                let image = UIImage(data:imgData)
                profileImage.image = image
            }
            profileImage.layer.borderWidth = 1
            profileImage.layer.masksToBounds = false
            profileImage.layer.borderColor = UIColor.black.cgColor
            profileImage.layer.cornerRadius = profileImage.frame.height/2
            profileImage.clipsToBounds = true
            
            nameLabel.text = profile.name
            gradyearLabel.text = "Class of \(profile.graduate)"
            bioTextView.text = profile.bio
            skill1Label.text = profile.skills[0]
            skill2Label.text = profile.skills[1]
            skill3Label.text = profile.skills[2]
            
        }
        
//        if let profile = getCurrentProfile() {
//            nameLabel.text = profile.name + ", Class of " + String(profile.graduate)
//            emailLabel.text = profile.schoolEmail
//            bioLabel.text = profile.bio
//            skillsLabel.text = profile.skills.joined(separator: ", ")
//
//            let url = URL(string: profile.photoURL)
//            let data = try? Data(contentsOf: url!)
//            if let imgData = data {
//                let image = UIImage(data:imgData)
//                imageView.image = image
//            }
//        }
    }
    
    @IBAction func sideButton(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
}
