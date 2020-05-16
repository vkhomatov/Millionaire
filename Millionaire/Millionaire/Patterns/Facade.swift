//
//  Facade.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 15.05.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation
import UIKit

class GamePromptsFacade {

    // подсказка 50/50
    func FiftyFiftyPrompt(promptCount: Int, for buttons: [UIButton]) {

        let currentQuestion = Game.shared.questions![Game.shared.game!.result.questionCount]
        var wrongQuestionsButtons = buttons
        
        for button in 0...buttons.count-1 {
            if buttons[button].titleLabel?.text == currentQuestion.rightAnswer {
                wrongQuestionsButtons.remove(at: button)
            }
        }
        
        for _ in 1...promptCount {
            let number = Int.random(in: 0 ... wrongQuestionsButtons.count-1)
            wrongQuestionsButtons[number].isEnabled = false
            wrongQuestionsButtons.remove(at: number)
        }
        
    }
    
    // подсказка Помощь друга и Помощь зала
    func PeopleAndFriendHelpPrompt(people: Bool, for buttons: [UIButton]) {
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.result.questionCount]
        var wrongQuestionsButtons = buttons
        
        if people  {
            for button in 0...wrongQuestionsButtons.count-1 {
                if buttons[button].titleLabel?.text != currentQuestion.rightAnswer && wrongQuestionsButtons.count > 2 && button <= (wrongQuestionsButtons.count-1)  {
                    wrongQuestionsButtons.remove(at: button)
                }
            }
        }
        
        wrongQuestionsButtons.randomElement()?.titleLabel?.textColor = .systemGreen
    }
    
}
