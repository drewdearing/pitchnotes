//
//  ViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 2/14/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func lockUI(){
        emailField.isEnabled = false
        passwordField.isEnabled = false
        loginButton.isEnabled = false
        registerButton.isEnabled = false
    }
    
    func unlockUI(){
        emailField.isEnabled = true
        passwordField.isEnabled = true
        loginButton.isEnabled = true
        registerButton.isEnabled = true
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        if let email = emailField.text {
            print("email done")
            if let password = passwordField.text {
                statusLabel.text = ""
                lockUI()
                print("password done")
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    guard let strongSelf = self else { return }
                    if let user = user {
                        Firestore.firestore().collection("profile").document(user.user.uid).getDocument(completion: { (doc, err) in
                            if let doc = doc {
                                self?.unlockUI()
                                if(doc.exists){
                                    print(doc.data())
                                    let data = doc.data()
                                    let setup = data!["setup"] as! Bool
                                    if setup {
                                        let name = data!["name"] as! String
                                        let schoolEmail = data!["schoolEmail"] as! String
                                        let bio = data!["bio"] as! String
                                        let skills = data!["skills"] as! [String]
                                        let graduate = data!["graduate"] as! Int
                                        let avatarURL = data!["photoURL"] as! String
                                        let userProfile = Profile(name: name, schoolEmail: schoolEmail, bio: bio, skills: skills, graduate: graduate, photoURL: avatarURL)
                                        UserDefaults.standard.set(try? PropertyListEncoder().encode(userProfile), forKey: "currentProfile")
                                        print("LOGIN SEGUE")
                                        self?.performSegue(withIdentifier: "LoginSegue", sender: self)
                                        return
                                    }
                                }
                                self?.performSegue(withIdentifier: "LoginSetupSegue", sender: self)
                                return
                            }
                        })
                    }
                    else{
                        self?.statusLabel.text = "Could not login!"
                        self?.unlockUI()
                    }
                }
            }
        }
    }
    
    // code to dismiss keyboard when user clicks on background
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

