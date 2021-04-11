//
//  PlanetTableViewCell.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 07.04.2021.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {

    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var TypeLocationLabel: UILabel!
    @IBOutlet weak var PopulationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        LocationLabel.textColor = UIColor(red: 0.338, green: 0.338, blue: 0.338, alpha: 1)
        TypeLocationLabel.textColor = UIColor(red: 0.338, green: 0.338, blue: 0.338, alpha: 1)
        PopulationLabel.textColor = UIColor(red: 0.635, green: 0.635, blue: 0.635, alpha: 1)
        
        TypeLocationLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        LocationLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        PopulationLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        
        self.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
    }
}
