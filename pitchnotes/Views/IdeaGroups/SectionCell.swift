//
//  SectionCell.swift
//  pitchnotes
//
//  Created by Xi Jin on 3/10/19.
//  Copyright © 2019 Drew Dearing. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {

    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var shadowLayer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainBackground.layer.cornerRadius = 8
        self.mainBackground.layer.masksToBounds = true
        
        self.shadowLayer.layer.masksToBounds = false
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.32
        self.shadowLayer.layer.shadowRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(title: String){
        mainTitle.text = title
    }
    
    func setImage(imageName: String){
        mainImage.image = UIImage(named: imageName)!
    }
    
}
