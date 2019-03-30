//
//  RegisterViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/30/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    func unlockUI(){
        self.emailField.isUserInteractionEnabled = true
        self.passwordField.isUserInteractionEnabled = true
        self.confirmField.isUserInteractionEnabled = true
        self.registerButton.isUserInteractionEnabled = true
        self.cancelButton.isUserInteractionEnabled = true
    }
    
    func lockUI(){
        self.emailField.isUserInteractionEnabled = false
        self.passwordField.isUserInteractionEnabled = false
        self.confirmField.isUserInteractionEnabled = false
        self.registerButton.isUserInteractionEnabled = false
        self.cancelButton.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func register(_ sender: Any) {
        if let email = emailField.text{
            if let password = passwordField.text{
                if let confirmPassword = confirmField.text  {
                    if confirmPassword == password {
                        lockUI()
                        statusLabel.text = "loading..."
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let user = authResult {
                                print(user.user.uid)
                                self.statusLabel.text = "User created!"
                                self.performSegue(withIdentifier: "RegisterSegue", sender: self)
                            }
                            else{
                                self.statusLabel.text = error!.localizedDescription
                                self.unlockUI()
                            }
                        }
                    }
                    else{
                        statusLabel.text = "Passwords don't match!"
                    }
                }
                else{
                    statusLabel.text = "Please confirm your password!"
                }
            }
            else{
                statusLabel.text = "Password is required!"
            }
        }
        else{
            statusLabel.text = "Email is required!"
        }
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
