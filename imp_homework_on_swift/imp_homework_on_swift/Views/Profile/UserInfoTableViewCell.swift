//
//  UserInfoTableViewCell.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 04.04.2021.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var InfoKeyLabel: UILabel!
    @IBOutlet weak var InfoValueLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        InfoKeyLabel.textColor = UIColor(red: 0.338, green: 0.338, blue: 0.338, alpha: 1)
        InfoKeyLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        InfoKeyLabel.text = "Дата Регистрации"
        self.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
