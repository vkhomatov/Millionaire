//
//  GameModel.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation
import UIKit


class GameSession  {
    
    
    public var onGameEnd: ((Int) -> Void)?

    var result = Result()
    var timer: Timer?
    var timeLeft: Int = 0
    var firstQuestion: Bool = true
  
    convenience init(answerCost: Int) {
        self.init()
        result.answerCost = answerCost
    }
    
    // вычисляем общий выигрыш исходя из кол-ва верных ответов
    func prizeCountF() -> Int {
        if result.rightAnswerCount > 0 {
            var sum: Int = 0
            for i in 0...result.rightAnswerCount-1 {
                sum += Int(pow(Double(2), Double(i)))
            }
            return Game.shared.firstAnswerCost * sum
        } else { return 0 }
    }
    
    // вычисляем дату начала игровой сессии
    func dateGameF() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    // вычисляем кол-во использованных подсказок
    func promtUseCountF() -> Int {
        var count: Int = 0
        if result.peopleHelpUse { count += 1 }
        if result.callToFriendUse { count += 1 }
        if result.fiftyFiftyUse { count += 1 }
        onGameEnd?(result.questionCount)

        return count
    }
    
    // устанавливаем текстовое значение параметра "перемешать вопросы"
    func randomQuestionsStringF() -> String {
        if Game.shared.shufflePosition == 1 {
            result.randomQuestionsString = "да"
            return "да" }
        else {
            result.randomQuestionsString = "нет"
            return "нет" }
    }
    
    // устанавливаем значения всех текущих параметров игры
    func setScreenQuestionData() -> ScreenData? {
        
        let questionData = QuestionData.init(question: Game.shared.questions![result.questionCount].question!,
                          rigthAnswer: Game.shared.questions![result.questionCount].rightAnswer!,
                          wrongAnswer1: Game.shared.questions![result.questionCount].wrongAnswer1!,
                          wrongAnswer2: Game.shared.questions![result.questionCount].wrongAnsver2!,
                          wrongAnswer3: Game.shared.questions![result.questionCount].wrongAnsver3!)
        
        let sessiondata = SessionData.init(questionCount: "ВОПРОС " + String(result.questionCount + 1) + " из " + String(Game.shared.questions!.count),
                         questionCost: "На кону " + String(result.answerCost) + " рублей",
                         rightAnswers: "правильных ответов " + String(result.questionCount),
                         prizeCount: "общий выигрыш  " + String(result.prizeCount) + " рублей")
        
        let sessionBuilder = SessionDataBuilder()
        sessionBuilder.set(sessionData: sessiondata)
        sessionBuilder.set(questionData: questionData)
        
        return sessionBuilder.build()
    }
    
    
    // конвертер таймера в текстовое представление
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
}


// структура результатов игры записываемая в UD
struct Result: Codable {
    
    var questionCount: Int = 0
    var rightAnswerCount: Int = 0
    var answerCost: Int = 0
    var prizeCount: Int = 0
    var peopleHelpUse: Bool = false
    var callToFriendUse: Bool = false
    var fiftyFiftyUse: Bool = false
    var dateGame: String = ""
    var promtUseCount: Int = 0
    var randomQuestionsString: String = "нет"
    
}
