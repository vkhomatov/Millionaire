//
//  AddQuestionModel.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 09.02.2021.
//  Copyright © 2021 Macrohard. All rights reserved.
//

import Foundation


class AddQuestionModel {
    
    var countQuestion: Int  = 0
    let dataCaretaker = DataCaretaker()

    
    // функция вроверки на правильность ввода и сохранения нового вопроса в базе ( вынести в модель и использовать Delegate )
    func saveNewQuestion(question : String?, rightAnswer : String?, wrongAnswer1 : String?, wrongAnswer2 : String?, wrongAnswer3 : String?) -> Int {
        
        if Game.shared.questions!.count > 0 {
            for count in 0...Game.shared.questions!.count-1 {
                if Game.shared.questions![count].question == question {
                    self.countQuestion = count
                    return 6
                }
            }
        }
        
        if question == "" { return 1 }
        if rightAnswer == "" { return 2 }
        if wrongAnswer1 == "" { return 3 }
        if wrongAnswer2 == "" { return 4 }
        if wrongAnswer3 == "" { return 5 }
        
        var newQuestion = Question()
        newQuestion.question = question
        newQuestion.rightAnswer = rightAnswer
        newQuestion.wrongAnswer1 = wrongAnswer1
        newQuestion.wrongAnsver2 = wrongAnswer2
        newQuestion.wrongAnsver3 = wrongAnswer3
        
        if Game.shared.questions != nil {
            Game.shared.questions?.append(newQuestion)
            dataCaretaker.saveQuestions(questions: Game.shared.questions!)
        } else { return 7 }
        
        return 0
        
    }
    
}
