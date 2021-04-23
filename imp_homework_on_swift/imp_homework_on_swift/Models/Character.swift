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

struct CharacterInfo: Codable {
    var name: String
    var gender: String
    var picture: Data?
    
    init(name: String, gender: String, picture: UIImage) {
        self.name = name
        self.gender = gender
        self.picture = picture.pngData()
    }
}
