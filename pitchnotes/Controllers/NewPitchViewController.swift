//
//  NewPitchViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 4/3/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class NewPitchViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        setUpTextView()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUpTextView() {
        textView.text = "Tap here to start composing your pitch!"
        textView.textColor = UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tap here to start composing your pitch!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCountLabel.text = String(170 - textView.text.count)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 170    // 10 Limit Value
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPublishPitch") {
            if let destination = segue.destination as? PublishPitchViewController {
                destination.pitchDescription = textView.text
            }
        }
    }
}
