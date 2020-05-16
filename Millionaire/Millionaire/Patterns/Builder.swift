//
//  Builder.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 16.05.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

class SessionDataBuilder {
    
    var question: QuestionData?
    var session: SessionData?
    
    func set(questionData: QuestionData) {
        self.question = questionData
    }
    
    func set(sessionData: SessionData) {
        self.session = sessionData
    }
    
    func build() -> ScreenData? {
        guard let question = question,
            let session = session else { return nil }
        return ScreenData(question: question, session: session)
    }
}

struct QuestionData {
    let question: String
    let rigthAnswer: String
    let wrongAnswer1: String
    let wrongAnswer2: String
    let wrongAnswer3: String
}

struct SessionData {
    let questionCount: String
    let questionCost: String
    let rightAnswers: String
    let prizeCount: String
}

struct ScreenData {
    let question: QuestionData
    let session: SessionData
}

