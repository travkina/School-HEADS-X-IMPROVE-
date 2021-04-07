//
//  PlanetListRespondsModel.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import Foundation

struct PlanetListRespondsModel: Decodable {
    let info: PlanetListInfoRespondsModel
    let results: [PlanetListResultRespondsModel]
}
struct PlanetListInfoRespondsModel: Decodable {
    let count: Int
    let pages: Int
    let next:  String?
    let prev:  String?
}

struct PlanetListResultRespondsModel: Decodable{
    let id: Int
    let name: String?
    let type: String?
    let dimension: String?
    let residents: [String]
}
