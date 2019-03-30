//
//  GroupViewController.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/10/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit
import FirebaseAuth

struct cellData {
    var opened = Bool()
    var title = String()
    var image = String()
    var sectionData = [MatchedIdeas]()
}

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SectionCell", bundle: nil), forCellReuseIdentifier: "SectionCell")
        
        tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "GroupCell")
        
        tableViewData = [cellData(opened: true, title: "Ideas Created By You", image: "idea-by-you", sectionData: []),
                         cellData(opened: true, title: "Ideas You Joined", image: "idea-by-others", sectionData: [])]
        
        let groups = Groups()
        groups.getGroups { (matchedGroups, error) in
            if let error = error{
                print("There is an error while fetching groups data: \(error)")
                return
            }
            self.tableViewData[0].sectionData = matchedGroups.created
            self.tableViewData[1].sectionData = matchedGroups.joined
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        let section = indexPath.section
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath) as! SectionCell
            cell.setTitle(title: tableViewData[section].title)
            cell.setImage(imageName: tableViewData[section].image)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
            //cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            cell.setAppName(name: tableViewData[section].sectionData[dataIndex].name)
            cell.setNumberOfMembers(count: tableViewData[section].sectionData[dataIndex].memberCount)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true{
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }else{
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }else{
            
            if let user = Auth.auth().currentUser {
                let data = tableViewData[indexPath.section].sectionData[indexPath.row-1]
                let vc = ChatViewController(user: user, title: String(data.name), channelId: data.id)
                navigationController?.pushViewController(vc, animated: true)
            }else{
                print("You are not logged in")
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let destination = segue.destination as! ChatViewController
//        if let indexPath = tableView.indexPathForSelectedRow {
//            //destination.ideaID = String(tableViewData[indexPath.section].sectionData[indexPath.row-1].id)
//            destination.title = String(tableViewData[indexPath.section].sectionData[indexPath.row-1].name)
//        }
//
//    }
    
}
