//
//  Character.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 17.04.2021.
//

import Foundation

struct Character: Codable {
    var name: String
    var gender: String
    var image: String
    var url: String

    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case image
        case url
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        image = try container.decode(String.self, forKey: .image)
        url = try container.decode(String.self, forKey: .url)
    }

}
 
