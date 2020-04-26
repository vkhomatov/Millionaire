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

    @IBOutlet weak var ShuffleQuestionSwitchControl: UISwitch!
    
    @IBAction func ShuffleQuestionsSwith(_ sender: UISwitch) {
        
        if sender.isOn == true {
            ShaffleQuestionsLabel.textColor = .systemGreen
            Game.shared.shufflePosition = 1
            
            DispatchQueue.main.async {
                Game.shared.questions = self.dataCaretaker.retrieveQuestions()
                Game.shared.questions?.shuffle()
            }
        } else if sender.isOn == false {
            ShaffleQuestionsLabel.textColor = .systemGray5
            Game.shared.shufflePosition = 0
            
            DispatchQueue.main.async {
                Game.shared.questions = self.dataCaretaker.retrieveQuestions()
            }
        }
        
    //    self.dataCaretaker.shufflePosition

        
    }
    
    @IBOutlet weak var ShaffleQuestionsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        Game.shared.results = self.dataCaretaker.retrieveResults()
        
        Game.shared.questions = self.dataCaretaker.retrieveQuestions()
                
        if Game.shared.questions?.count == 0 {
            Game.shared.getQuestions(shuffle: false)
            if Game.shared.questions != nil {
                self.dataCaretaker.saveQuestions(questions: Game.shared.questions!)
            }
        }
        
//        guard let shuffle = Game.shared.readUserSetup() else {
//            self.ShuffleQuestionSwitchControl.isOn = false
//            Game.shared.shuffleQuestions = false
//            Game.shared.saveUserSetup(shuffle: Game.shared.shuffleQuestions)
//            return }
        
       // Game.shared.shuffleQuestions = self.dataCaretaker.shufflePosition
        
        if Game.shared.shufflePosition == 1 {
           self.ShuffleQuestionSwitchControl.isOn = true
            Game.shared.questions?.shuffle()

        }
      
//            switch Game.shared.shuffleQuestions {
//            case true?:
//                self.ShuffleQuestionSwitchControl.isOn = true
//                Game.shared.shuffleQuestions = true
//            case false?:
//                self.ShuffleQuestionSwitchControl.isOn = false
//                Game.shared.shuffleQuestions = false
//            case .none:
//                self.ShuffleQuestionSwitchControl.isOn = false
//                Game.shared.shuffleQuestions = false
//                return
//        }
    
            
       
        
    }
    
//    override func viewDidDisappear(_ anibmated: Bool) {
//
//        self.dataCaretaker.saveUserSetup()
//
//    }
    
    

}
