//
//  ProfileSetupViewController.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/30/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

struct Profile : Codable {
    var name: String
    var schoolEmail: String
    var bio: String
    var skills: [String]
    var graduate: Int
    var photoURL: String
}

func getCurrentProfile() -> Profile?{
    let data = UserDefaults.standard.value(forKey: "currentProfile") as? Data
    if let data = data {
        let profile:Profile? = try? PropertyListDecoder().decode(Profile.self, from: data)
        return profile
    }
    return nil
}

class ProfileSetupViewController: UIViewController, ImagePickerDelegate {
    var imagePicker:ImagePicker!
    var selectedImage:UIImage?
    var avatarURL:String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var skill1Field: UITextField!
    @IBOutlet weak var skill2Field: UITextField!
    @IBOutlet weak var skill3Field: UITextField!
    @IBOutlet weak var graduationField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var selectImageButton: UIButton!
    
    func unlockUI(){
        self.firstNameField.isUserInteractionEnabled = true
        self.lastNameField.isUserInteractionEnabled = true
        self.emailField.isUserInteractionEnabled = true
        self.bioField.isUserInteractionEnabled = true
        self.skill1Field.isUserInteractionEnabled = true
        self.skill2Field.isUserInteractionEnabled = true
        self.skill3Field.isUserInteractionEnabled = true
        self.graduationField.isUserInteractionEnabled = true
        self.selectImageButton.isUserInteractionEnabled = true
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
        self.selectImageButton.isUserInteractionEnabled = false
        self.doneButton.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
    
    func didSelect(image: UIImage?) {
        selectedImage = image
        imageView.image = image
    }
    
    func getRequiredFields(complete: @escaping (Profile?) -> Void){
        if let name = getName(){
            if let email = getEmail() {
                if let bio = bioField.text {
                    if let skills = getSkills() {
                        if let graduationYear = getGraduationYear() {
                            if let image = selectedImage {
                                uploadImage(image: image) { (url) in
                                    if let avatarURL = url {
                                        let requiredFields = Profile(name: name, schoolEmail: email, bio: bio, skills: skills, graduate: graduationYear, photoURL: avatarURL)
                                        complete(requiredFields)
                                    }
                                }
                            }
                            else{
                                statusLabel.text = "Please select an avatar!"
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
        complete(nil)
    }
    
    private func uploadImage(image:UIImage, complete: @escaping (String?) -> Void){
        SVProgressHUD.show(withStatus: "Loading...")
        let currentUser = Auth.auth().currentUser
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let data = image.pngData()
        let imageName = "profile_" + currentUser!.uid
        print(imageName)
        let imageRef = storageRef.child("\(imageName).png")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard url != nil else {
                    return
                }
                //do things that u want to do after download is done
                if let urlText = url?.absoluteString {
                    complete(urlText)
                }
            }
        }
        complete(nil)
    }
    
    @IBAction func selectImage(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBAction func done(_ sender: Any) {
        lockUI()
        getRequiredFields(complete: { (fields) in
            if let requiredFields = fields {
                self.statusLabel.text = "Loading..."
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
                        DispatchQueue.main.async {
                            self.statusLabel.text = "Done!"
                            UserDefaults.standard.set(try? PropertyListEncoder().encode(requiredFields), forKey: "currentProfile")
                            self.performSegue(withIdentifier: "ProfileSetupSegue", sender: self)
                        }
                    }
                    task.resume()
                }
            }
            else{
                self.unlockUI()
            }
        })
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
