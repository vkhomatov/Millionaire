//
//  GameController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    
    private let dataCaretaker = DataCaretaker()
    
    @IBOutlet weak var GameTimerOnOffLabel: UILabel!
    @IBOutlet weak var ShuffleQuestionSwitchControl: UISwitch!
    @IBOutlet weak var GameTimerOnOffSwithControl: UISwitch!
    @IBOutlet weak var ShaffleQuestionsLabel: UILabel!
    
    
    @IBAction func GameTimerOnOffSwith(_ sender: UISwitch) {
        if sender.isOn == true {
            Game.shared.timerPosition = 1
            GameTimerOnOffLabel.textColor = .systemGreen
        } else if sender.isOn == false {
            Game.shared.timerPosition = 0
            GameTimerOnOffLabel.textColor = .systemGray5
        }
    }
    
    @IBAction func ShuffleQuestionsSwith(_ sender: UISwitch) {
        //перенести функционал в модель использовать Delegate
        if sender.isOn == true {
            ShaffleQuestionsLabel.textColor = .systemGreen
            Game.shared.shufflePosition = 1
            DispatchQueue.main.async {
                Game.shared.questions = self.dataCaretaker.retrieveQuestions()
            }
        } else if sender.isOn == false {
            ShaffleQuestionsLabel.textColor = .systemGray5
            Game.shared.shufflePosition = 0
            DispatchQueue.main.async {
                Game.shared.questions = self.dataCaretaker.retrieveQuestions()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.shared.results = self.dataCaretaker.retrieveResults()
        Game.shared.questions = self.dataCaretaker.retrieveQuestions()
        
        // перенести функционал в модель
        if Game.shared.questions?.count == 0 {
            Game.shared.getQuestions()
            if Game.shared.questions != nil {
                self.dataCaretaker.saveQuestions(questions: Game.shared.questions!)
            }
        }
        
        // перенести функционал в модель
        if Game.shared.shufflePosition == 1 {
            self.ShuffleQuestionSwitchControl.isOn = true
            ShaffleQuestionsLabel.textColor = .systemGreen
        }
        
        if Game.shared.timerPosition == 1 {
            self.GameTimerOnOffSwithControl.isOn = true
            GameTimerOnOffLabel.textColor = .systemGreen
        }
    }
    
    @IBAction func returnToGame(unwindSegue: UIStoryboardSegue) {
        // почему без этой функции не работает unwind segue???
        Game.shared.game = nil
    }
    
    
}
