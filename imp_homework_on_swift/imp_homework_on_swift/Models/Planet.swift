//
//  Planet.swift
//  imp_homework_on_swift
//
//  Created by Татьяна  Травкина on 09.04.2021.
//

import Foundation

struct Planet: Decodable {
    
    var idl: Int
    var namel: String
    var type: String
    var dimension: String
    var residents: [String]

    enum CodingKeys: String, CodingKey {
        case idl = "id"
        case namel = "name"
        case type
        case dimension
        case residents
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idl = try container.decode(Int.self, forKey: .idl)
        namel = try container.decode(String.self, forKey: .namel)
        type = try container.decode(String.self, forKey: .type)
        dimension = try container.decode(String.self, forKey: .dimension)
        residents = try container.decode([String].self, forKey: .residents)
    }
}

