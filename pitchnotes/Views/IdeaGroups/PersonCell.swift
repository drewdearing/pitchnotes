//
//  PersonCell.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/11/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personImage.layer.borderWidth = 1
        personImage.layer.masksToBounds = false
        personImage.layer.borderColor = UIColor.black.cgColor
        personImage.layer.cornerRadius = personImage.frame.height/2
        personImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setName(name: String){
        self.nameLabel.text = name
    }
    func setbio(bio: String){
        self.bioLabel.text = bio
    }
    func setPersonImage(photoURL: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: photoURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.personImage.image = image
                    }
                }
            }
        }
    }
}
