//
//  RespondsModel.swift
//  imp_homework_on_swift
//
//  Created by Студент 1 on 05.04.2021.
//

import Foundation

struct RespondsModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case info
        case results
    }
    
    let info: InfoRespondsModel
    let results: [Planet]
}
struct InfoRespondsModel: Codable {
    let count: Int
    let pages: Int
    let next:  String?
    let prev:  String?
}
