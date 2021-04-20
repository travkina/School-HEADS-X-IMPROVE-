//
//  Planet.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 09.04.2021.
//

import Foundation

struct Planet: Codable {

    var name: String
    var type: String
    var dimension: String
    var residents: [String]

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case type
        case dimension
        case residents
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        dimension = try container.decode(String.self, forKey: .dimension)
        residents = try container.decode([String].self, forKey: .residents)
    }

}
