//
//  ChatViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var ideaID = "mPtn22PT65EKCdZ4CaWD"
    var row = -1
    var section = -1
    var currentMembers = MembersInGroup(members: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let members = Members(ideaID: ideaID)
        members.getMembers { (membersInGroup, error) in
            if let error = error{
                print("There is an error while fetching members data: \(error)")
                return
            }
            self.currentMembers = membersInGroup
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMembers.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! PersonCell
        let row = indexPath.row
        cell.setName(name: currentMembers.members[row].name)
        cell.setbio(bio: currentMembers.members[row].bio)
        cell.setPersonImage(photoURL: URL(string: currentMembers.members[row].photoURL)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
