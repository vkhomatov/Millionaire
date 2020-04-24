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
    
    
    var randomQuestions: Bool {
        get {
            return Game.shared.shuffleQuestions
        }
    }
    
    var dateGame: String {
        get {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
    }
    
    var promtUseCount: Int {
        get {
            var count: Int = 0
            if peopleHelpUse { count += 1 }
            if callToFriendUse { count += 1 }
            if fiftyFiftyUse { count += 1 }
            return count
        }
    }
    
    var randomQuestionsString: String {
        get {
            if randomQuestions { return "да" } else { return "нет" }
        }
    }
    
    convenience init(answerCost: Int, randomQuestions: Bool, rightAnswerCount: Int, prizeCount: Int, peopleHelpUse: Bool, callToFriendUse: Bool, fiftyFiftyUse: Bool) {
        self.init()
        
        self.answerCost = answerCost
        self.prizeCount = prizeCount
        self.rightAnswerCount = rightAnswerCount
        self.peopleHelpUse = peopleHelpUse
        self.callToFriendUse = callToFriendUse
        self.fiftyFiftyUse = fiftyFiftyUse
    }
    
}
