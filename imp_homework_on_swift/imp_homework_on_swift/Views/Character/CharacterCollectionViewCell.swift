//
//  CharacterCollectionViewCell.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//

import UIKit
class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = .black
        genderLabel.textColor = UIColor(red: 0.338, green: 0.338, blue: 0.338, alpha: 1)
        
        nameLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        genderLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        
        characterImage.contentMode = .scaleAspectFit
        characterImage.image = UIImage(named: "ph")
        self.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.338, green: 0.338, blue: 0.338, alpha: 1).cgColor
    }
}
