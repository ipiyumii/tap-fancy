//
//  TriviaQuestion.swift
//  Tap fancy
//
//  Created by Piyumi Imalka on 2026-07-01.
//

import Foundation

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
    
    var allAnswers: [String] {
        return (incorrectAnswers + [correctAnswer]).shuffled()
    }
}
