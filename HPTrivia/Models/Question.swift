//
//  Question.swift
//  HPTrivia
//
//  Created by Abhishek on 09/02/26.
//

struct Question: Codable {
    let id: Int
    let question: String
    let answer: String
    let wrong: [String]
    let book: Int
    let hint: String
}
