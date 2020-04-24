//
//  GameModel.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 22.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

final class Game {
    
    static let shared = Game()
    
    private init() { }
    
    let firstAnswerCost = 100
    
    var game: GameSession?
        
    var shuffleQuestions: Bool = false

    // массив вопросов, сохраняем в UD и загружаем из UD
    var questions : [Question]?
    
    //массив результатов игр, сохраняем в UD и загружаем из UD
    var results : [GameSession]?
    
    
    func getQuestions(shuffle: Bool) {
        
        var questionBase = [Question]()
        let question1 = Question(question: "1+1", rightAnswer: "2", wrongAnswer1: "3", wrongAnsver2: "4", wrongAnsver3: "5")
        let question2 = Question(question: "1+2", rightAnswer: "3", wrongAnswer1: "4", wrongAnsver2: "5", wrongAnsver3: "6")
        let question3 = Question(question: "1+3", rightAnswer: "4", wrongAnswer1: "5", wrongAnsver2: "6", wrongAnsver3: "7")
        let question4 = Question(question: "1+4", rightAnswer: "5", wrongAnswer1: "6", wrongAnsver2: "7", wrongAnsver3: "8")
        let question5 = Question(question: "1+5", rightAnswer: "6", wrongAnswer1: "7", wrongAnsver2: "8", wrongAnsver3: "9")
        let question6 = Question(question: "1+6", rightAnswer: "7", wrongAnswer1: "8", wrongAnsver2: "9", wrongAnsver3: "10")
        let question7 = Question(question: "1+7", rightAnswer: "8", wrongAnswer1: "9", wrongAnsver2: "10", wrongAnsver3: "11")
        let question8 = Question(question: "1+8", rightAnswer: "9", wrongAnswer1: "10", wrongAnsver2: "11", wrongAnsver3: "12")
        let question9 = Question(question: "1+9", rightAnswer: "10", wrongAnswer1: "11", wrongAnsver2: "12", wrongAnsver3: "13")
        let question10 = Question(question: "1+10", rightAnswer: "11", wrongAnswer1: "12", wrongAnsver2: "13", wrongAnsver3: "14")
        
        
        questionBase.append(question1)
        questionBase.append(question2)
        questionBase.append(question3)
        questionBase.append(question4)
        questionBase.append(question5)
        questionBase.append(question6)
        questionBase.append(question7)
        questionBase.append(question8)
        questionBase.append(question9)
        questionBase.append(question10)
        
        if shuffle {
            questionBase.shuffle()
          //  questionBase.shuffle()
          //  questionBase.shuffle()
        }
        
        questions = questionBase
        
        
        
    }
    
    func saveQuestion(newQuestion: Question) {
        
        if questions == nil { return }
        
        if (newQuestion.question != "" && newQuestion.rightAnswer != "" && newQuestion.wrongAnswer1 != "" && newQuestion.wrongAnsver3 != "" && newQuestion.wrongAnsver3 != "") {
            questions?.append(newQuestion)
            print("Вопрос записан в базу")
        } else { print("Вопрос сформирован неправильно, проверьте заполнение всех необходимых полей") }
        
    }
    
    
    func getGameResults() {
        
        var resultsBase =  [GameSession]()
        
        
        let result1 = GameSession(answerCost: firstAnswerCost, randomQuestions: false, rightAnswerCount: 5, prizeCount: 6500, peopleHelpUse: true, callToFriendUse: false, fiftyFiftyUse: false)
        let result2 = GameSession(answerCost: firstAnswerCost, randomQuestions: true, rightAnswerCount: 4, prizeCount: 3200, peopleHelpUse: true, callToFriendUse: true, fiftyFiftyUse: false)
        let result3 = GameSession(answerCost: firstAnswerCost, randomQuestions: false, rightAnswerCount: 3, prizeCount: 1800, peopleHelpUse: true, callToFriendUse: true, fiftyFiftyUse: true)
        
        resultsBase.append(result1)
        resultsBase.append(result2)
        resultsBase.append(result3)
        
        results = resultsBase
        
    }
    
    func saveGameResults(newGame: GameSession) {
        
        if results != nil {
            results?.append(newGame)
            print("Результат игры записан в базу")
        }
    }
    
    
}

struct Question: Equatable {
    
    var question : String?
    var rightAnswer : String?
    var wrongAnswer1 : String?
    var wrongAnsver2 : String?
    var wrongAnsver3 : String?
    
    //init() {}
}
