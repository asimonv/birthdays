//
//  BirthdayCell.swift
//  Birthdays
//
//  Created by Andre Simon on 18-01-21.
//

import UIKit

class BirthdayCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageBackgroundView: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileBadgeLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.black.cgColor
        profileImageBackgroundView.layer.cornerRadius = profileImageBackgroundView.frame.width / 2
    }
    
}
