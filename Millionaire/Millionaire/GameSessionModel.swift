//
//  GameModel.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation


class GameSession  {
    
    var result = Result()

    func dateGameF() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func promtUseCountF() -> Int {
        var count: Int = 0
        if result.peopleHelpUse { count += 1 }
        if result.callToFriendUse { count += 1 }
        if result.fiftyFiftyUse { count += 1 }
        return count
    }
    
    func randomQuestionsStringF() ->String {
        if Game.shared.shufflePosition == 1 {
            result.randomQuestionsString = "да"
            return "да" }
        else {
            result.randomQuestionsString = "нет"
            return "нет" }
    }
    
    convenience init(answerCost: Int) {
        self.init()
        result.answerCost = answerCost
    }

}


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
