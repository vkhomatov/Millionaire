//
//  GameModel.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

class GameSession: Codable {
    
    var questionCount: Int = 0
    var rightAnswerCount: Int = 0
    var answerCost: Int = 0
    var prizeCount: Int = 0
    var peopleHelpUse: Bool = false
    var callToFriendUse: Bool = false
    var fiftyFiftyUse: Bool = false
   // var randomQuestions: Bool = false
    var dateGame: String = ""
    var promtUseCount: Int = 0
     var randomQuestionsString: String = "нет"
    
    
//    func randomQuestionsF() -> Bool {
//
//            return Game.shared.shuffleQuestions!
//
//    }
    
    func dateGameF() -> String {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            return dateString
    }
    
    func promtUseCountF() -> Int {
    
            var count: Int = 0
            if peopleHelpUse { count += 1 }
            if callToFriendUse { count += 1 }
            if fiftyFiftyUse { count += 1 }
            return count
        
    }
    
    func randomQuestionsStringF() ->String {
        //if Game.shared.shuffleQuestions != nil {
        if Game.shared.shufflePosition == 1 {
           // randomQuestions = true
            randomQuestionsString = "да"
            return "да" }
        else {
         //   randomQuestions = false
            randomQuestionsString = "нет"
            return "нет" }
       // }
        // return "нет"
    }
    
    
    convenience init(answerCost: Int) {
        self.init()
        self.answerCost = answerCost
        
    }
    
//    convenience init(answerCost: Int, randomQuestions: Bool, rightAnswerCount: Int, prizeCount: Int, peopleHelpUse: Bool, callToFriendUse: Bool, fiftyFiftyUse: Bool) {
//        self.init()
//        
//        self.answerCost = answerCost
//        self.prizeCount = prizeCount
//        self.rightAnswerCount = rightAnswerCount
//        self.peopleHelpUse = peopleHelpUse
//        self.callToFriendUse = callToFriendUse
//        self.fiftyFiftyUse = fiftyFiftyUse
//    }
    
}
