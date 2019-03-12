//
//  GroupCell.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/10/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var numberOfMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAppName(name: String){
        self.appName.text = name
    }
    func setNumberOfMembers(count: Int){
        self.numberOfMembers.text = String(count)
    }
    
}
