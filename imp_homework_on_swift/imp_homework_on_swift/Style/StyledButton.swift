//
//  StyledButton.swift
//  travkina_prj
//
//  Created by Студент 1 on 19.03.2021.
//

import UIKit

//@IBDesignable
class StyledButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.setView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setView()
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .white : UIColor(red: 0.192, green: 0.406, blue: 0.958, alpha: 1)
        }
    }
    
    private func setView() {
        backgroundColor = UIColor(red: 0.192, green: 0.406, blue: 0.958, alpha: 1)
    }
    
}
