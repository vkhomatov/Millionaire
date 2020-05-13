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
    
    var result = Result()
    var timer: Timer?
    var timeLeft: Int = 0// Game.shared.questions!.count * 60
    var firstQuestion: Bool = true
    
   // var vc = GameSessionController() //GameSessionController()
    

    
    convenience init(answerCost: Int) {
        self.init()
        result.answerCost = answerCost
        print("answerCost = \(answerCost)")
       // vc = GameSessionController()
      //  vc.gameDelegate = self as? GameSessionControllerDelegate
        
        
        //как объявить делегата вьюконтроллера в модели?
      //  model.vcFour.delegate = self

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
    
    
    // конвертер таймера в текстовое представление
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
//    func nextQuestion(labelText: String, buttons: [UIButton]) {
//                   labelText = Game.shared.questions![result.questionCount].question
//                   answerButtons[0].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].rightAnswer, for: .normal)
//                   answerButtons[1].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnswer1, for: .normal)
//                   answerButtons[2].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver2, for: .normal)
//                   answerButtons[3].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver3, for: .normal)
//    }
    
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
