//
//  PlanetListRespondsModel.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import Foundation

struct PlanetListRespondsModel<T: Decodable>: Decodable {
    private enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    let info: PlanetListInfoRespondsModel
    let results: [T]
}
struct PlanetListInfoRespondsModel: Decodable {
    let count: Int
    let pages: Int
    let next:  String?
    let prev:  String?
}
