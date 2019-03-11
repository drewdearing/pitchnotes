//
//  ChatViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var ideaID = "4fzdvhIlhqAMq8GYTvtu"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let members = Members(ideaID: ideaID)
        members.getMembers { (membersInGroup, error) in
            if let error = error{
                print("There is an error while fetching members data: \(error)")
                return
            }
            print("I am going to reload the table view")
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
