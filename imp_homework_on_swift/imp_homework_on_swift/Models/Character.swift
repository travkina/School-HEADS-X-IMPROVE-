//
//  Character.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//
import UIKit
import Foundation

struct Character: Codable {
    
    var name: String
    var gender: String
    var image: String
    var url: String
}

struct CharacterInfo {
    var name: String
    var gender: String
    var picture = UIImage()
    var miniPicture = UIImage()
}
