//
//  Strategy.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 26.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

//class yesTimer: ShuffleQuestionsStrategy {
//    func shuffle(questions: [Question]) -> [Question]? {
//        return questions
//    }
//}

class yesShuffle: ShuffleQuestionsStrategy {
    func shuffle() {
        if Game.shared.questions != nil {
            Game.shared.questions!.shuffle()
        }

    }
}


//class yesShuffle: ShuffleQuestionsStrategy {
//    func shuffle(questions: [Question]?) -> [Question]? {
//        if questions != nil {
//        return questions!.shuffled()
//        } else { return nil }
//    }
//}

