//
//  UICollectionViewCell+NibName.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//

import UIKit

extension UICollectionViewCell {
    static func nibName() -> String {
        String(describing: Self.self)
    }
}
