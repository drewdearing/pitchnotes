//
//  PublishPitchViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 4/3/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import SVProgressHUD

class PublishPitchViewController: UIViewController {
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var categoryTextView: UITextField!
    @IBOutlet weak var colorSlider: UISlider!
    @IBOutlet weak var colorView: UIView!
    
    var pitchDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //rounded corner
        publishButton.layer.cornerRadius = 5
        
        colorView.backgroundColor = UIColor(hue: CGFloat(colorSlider!.value), saturation: 1, brightness: 1, alpha: 1)

    }
    
    @IBAction func colorChanged(_ sender: Any) {
        colorView.backgroundColor = UIColor(hue: CGFloat(colorSlider!.value), saturation: 1, brightness: 1, alpha: 1)
    }
    
    @IBAction func publishPressed(_ sender: Any) {
        publishButton.isEnabled = false
        titleText.isEnabled = false
        categoryTextView.isEnabled = false
        if let title = titleText.text,
           let category = categoryTextView.text,
           pitchDescription != ""{
            if title == "" || category == "" {
                let alert = UIAlertController(title: "Warning", message: "Please fill in all the fields before publish", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let myNewPitch = MyNewPitch(name: title, description: pitchDescription, category: category, hue: colorSlider.value)
            let pitch = NewPitch()
            pitch.postNewPitch(completion: { (MyNewPitch, error) in
                if let error = error{
                    let alert = UIAlertController(title: "Error", message: (error as! String), preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    self.publishButton.isEnabled = true
                    self.titleText.isEnabled = true
                    self.categoryTextView.isEnabled = true
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "Pitch Posted!")
                self.dismiss(animated: true, completion: nil)

            }, myNewPitch: myNewPitch)

        }else{
            // create the alert
            let alert = UIAlertController(title: "Warning", message: "Please fill in all the fields before publish", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
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
