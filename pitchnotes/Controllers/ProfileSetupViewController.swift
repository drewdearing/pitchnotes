//
//  ProfileSetupViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/30/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import Firebase

struct Profile : Codable {
    var name: String
    var schoolEmail: String
    var bio: String
    var skills: [String]
    var graduate: Int
    var photoURL: String
}

class ProfileSetupViewController: UIViewController {
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var skill1Field: UITextField!
    @IBOutlet weak var skill2Field: UITextField!
    @IBOutlet weak var skill3Field: UITextField!
    @IBOutlet weak var graduationField: UITextField!
    @IBOutlet weak var avatarURLField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    func unlockUI(){
        self.firstNameField.isUserInteractionEnabled = true
        self.lastNameField.isUserInteractionEnabled = true
        self.emailField.isUserInteractionEnabled = true
        self.bioField.isUserInteractionEnabled = true
        self.skill1Field.isUserInteractionEnabled = true
        self.skill2Field.isUserInteractionEnabled = true
        self.skill3Field.isUserInteractionEnabled = true
        self.graduationField.isUserInteractionEnabled = true
        self.avatarURLField.isUserInteractionEnabled = true
        self.doneButton.isUserInteractionEnabled = true
    }
    
    func lockUI(){
        self.firstNameField.isUserInteractionEnabled = false
        self.lastNameField.isUserInteractionEnabled = false
        self.emailField.isUserInteractionEnabled = false
        self.bioField.isUserInteractionEnabled = false
        self.skill1Field.isUserInteractionEnabled = false
        self.skill2Field.isUserInteractionEnabled = false
        self.skill3Field.isUserInteractionEnabled = false
        self.graduationField.isUserInteractionEnabled = false
        self.avatarURLField.isUserInteractionEnabled = false
        self.doneButton.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getName() -> String? {
        if let first = self.firstNameField.text {
            if let last = self.lastNameField.text {
                if first != "" && last != "" {
                    return first + " " + last
                }
                else{
                    return nil
                }
            }
        }
        return nil
    }
    
    func getSkills() -> [String]? {
        if let skill1 = skill1Field.text{
            if skill1 == "" {
                return nil
            }
            var skills:[String] = [skill1]
            if let skill2 = skill2Field.text {
                if skill2 != "" {
                    skills.append(skill2)
                }
            }
            if let skill3 = skill3Field.text{
                if skill3 != "" {
                    skills.append(skill3)
                }
            }
            return skills
        }
        return nil
    }
    
    func getGraduationYear() -> Int? {
        if let graduationYear = graduationField.text {
            if let graduationInt = Int(graduationYear) {
                return graduationInt
            }
        }
        return nil
    }
    
    func getEmail() -> String? {
        if let email = emailField.text {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: email) {
                return email
            }
        }
        return nil
    }
    
    func getAvatarURL() -> String? {
        if let avatarURL = avatarURLField.text {
            if let url = NSURL(string: avatarURL) {
                if UIApplication.shared.canOpenURL(url as URL) {
                    return avatarURL
                }
            }
        }
        return nil
    }
    
    func getRequiredFields() -> Profile? {
        if let name = getName(){
            if let email = getEmail() {
                if let bio = bioField.text {
                    if let skills = getSkills() {
                        if let graduationYear = getGraduationYear() {
                            if let avatarURL = getAvatarURL() {
                                let requiredFields = Profile(name: name, schoolEmail: email, bio: bio, skills: skills, graduate: graduationYear, photoURL: avatarURL)
                                return requiredFields
                            }
                            else{
                                statusLabel.text = "Please enter a valid Avatar URL!"
                            }
                        }
                        else{
                            statusLabel.text = "Please enter a valid graduation year!"
                        }
                    }
                    else{
                        statusLabel.text = "Please provide at lease 1 skill!"
                    }
                }
                else{
                    statusLabel.text = "Please provide Bio!"
                }
            }
            else{
                statusLabel.text = "Please enter a valid email!"
            }
        }
        else{
            statusLabel.text = "Please enter a first and last name!"
        }
        return nil
    }
    
    @IBAction func done(_ sender: Any) {
        lockUI()
        if let requiredFields = getRequiredFields() {
            statusLabel.text = "Loading..."
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if error != nil {
                    // Handle error
                    return;
                }
                guard let uploadData = try? JSONEncoder().encode(requiredFields) else {
                    return
                }
                let urlPathBase = "https://us-central1-pitchnote-f1fd4.cloudfunctions.net/user/"
                let request = NSMutableURLRequest()
                request.url = URL(string: urlPathBase)
                request.httpMethod = "PUT"
                request.addValue("Bearer "+idToken!, forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let task = URLSession.shared.uploadTask(with: request as URLRequest, from: uploadData) { data, response, error in
                    if let error = error {
                        print ("error: \(error)")
                        return
                    }
                    guard let response = response as? HTTPURLResponse,
                        (200...299).contains(response.statusCode) else {
                            print ("server error")
                            return
                    }
                    if let mimeType = response.mimeType,
                        mimeType == "application/json",
                        let data = data,
                        let dataString = String(data: data, encoding: .utf8) {
                        print ("got data: \(dataString)")
                    }
                    self.statusLabel.text = "Done!"
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(requiredFields), forKey: "profile")
                    self.performSegue(withIdentifier: "ProfileSetupSegue", sender: self)
                }
                task.resume()
            }
        }
        else{
            unlockUI()
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
