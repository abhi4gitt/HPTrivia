//
//  Book.swift
//  HPTrivia
//
//  Created by Abhishek on 11/02/26.
//

import Foundation

struct Book: Identifiable {
    let id: Int
    let image: String
    let questions: [Question]
    let status: BookStatus
    
    enum BookStatus {
        case active, inactive, locked
    }
}
