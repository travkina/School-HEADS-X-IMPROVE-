//
//  TopTableViewCell.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 04.04.2021.
//

import UIKit

class TopTableViewCell: UITableViewCell {

    @IBOutlet weak var UserLoginLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var TopImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
