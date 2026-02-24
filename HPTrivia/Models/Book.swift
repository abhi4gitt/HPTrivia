//
//  Book.swift
//  HPTrivia
//
//  Created by Abhishek on 11/02/26.
//

import Foundation

struct Book: Codable, Identifiable {
    let id: Int
    let image: String
    let questions: [Question]
    var status: BookStatus
}

enum BookStatus: Codable {
    case active, inactive, locked
}
