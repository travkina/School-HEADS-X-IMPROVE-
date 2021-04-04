//
//  UITableViewCell+NibName.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 04.04.2021.
//

import UIKit

extension UITableViewCell {
    static func nibName() -> String {
        String(describing: Self.self)
    }
}
