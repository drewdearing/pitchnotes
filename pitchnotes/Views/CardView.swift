//
//  CardView.swift
//  pitchnotes
//
//  Created by Drew Dearing on 3/10/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

struct SwipeData: Codable{
    var isUser:Bool
    var userUid:String
    var ideaUid:String
    var like:Bool
}

class CardView: UIView {
    
    let swipeOverlay = UIView()
    
    var isUser:Bool?
    var userUid:String?
    var ideaUid:String?
    
    override init(frame: CGRect){
        //swipe gesture
        super.init(frame: frame)
        initCardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCardView()
    }
    
    private func initCardView(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    func swipeRight(){
        self.swipeRequest(like:true)
        let x = self.superview!.frame.width/2
        let degrees = x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = rotationalTransform.translatedBy(x: x, y: 0)
            self.layer.opacity = 0
            self.swipeOverlay.backgroundColor = .green
            self.swipeOverlay.layer.opacity = 1.0
            
        }, completion:{ (bool) in
            self.removeFromSuperview()
        })
    }
    
    func swipeLeft(){
        self.swipeRequest(like:false)
        let x = -self.superview!.frame.width/2
        let degrees = x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = rotationalTransform.translatedBy(x: x, y: 0)
            self.layer.opacity = 0
            self.swipeOverlay.backgroundColor = .red
            self.swipeOverlay.layer.opacity = 1.0
        }, completion:{ (bool) in
            self.removeFromSuperview()
        })
    }
    
    func swipeRequest(like:Bool) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                // Handle error
                return;
            }
            let swipeData = SwipeData(isUser: self.isUser!, userUid: self.userUid!, ideaUid: self.ideaUid!, like: like)
            guard let uploadData = try? JSONEncoder().encode(swipeData) else {
                return
            }
            let urlPathBase = "https://us-central1-pitchnote-f1fd4.cloudfunctions.net/swipe/"
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
            }
            task.resume()
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed:
            handleGestureChange(gesture)
        case .ended:
            handleGestureEnd(gesture)
        default:
            ()
        }
    }
    
    func handleGestureEnd(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let shouldDismiss = abs(translation.x) > (self.superview!.frame.width/2)
        let like = translation.x > 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if(shouldDismiss){
                self.layer.opacity = 0
                self.removeFromSuperview()
                self.swipeRequest(like:like)
            }
            else{
                self.layer.opacity = 1
                self.transform = .identity
                self.swipeOverlay.layer.opacity = 0
                self.swipeOverlay.backgroundColor = .white
            }
        })
    }
    
    func handleGestureChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
        self.layer.opacity = Float(1-(abs(translation.x)/(self.superview!.frame.width/2)))
        if(translation.x > 0){
            swipeOverlay.backgroundColor = .green
        }
        else if(translation.x < 0){
            swipeOverlay.backgroundColor = .red
        }
        else {
            swipeOverlay.backgroundColor = .white
        }
        
        swipeOverlay.layer.opacity = 1.0-self.layer.opacity
    }

}
