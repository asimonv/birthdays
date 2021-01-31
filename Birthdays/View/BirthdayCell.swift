//
//  BirthdayCell.swift
//  Birthdays
//
//  Created by Andre Simon on 18-01-21.
//

import UIKit

class BirthdayCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override func draw(_ rect: CGRect) {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
    
}
