//
//  EndGameController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class EndGameController: UIViewController {

    @IBOutlet weak var RightAnswerCountLabel: UILabel!
    @IBOutlet weak var GamePrizeLabel: UILabel!
    @IBOutlet weak var AllAnswersCountLabel: UILabel!

    @IBOutlet weak var HelpPeopleUseLabel: UILabel!
    @IBOutlet weak var CallToFriendUseLabel: UILabel!
    @IBOutlet weak var FiftyFiftyUseLabel: UILabel!
    @IBOutlet weak var GameOverLabel: UILabel!
    
    @IBOutlet weak var ShuffleQuestionsLabel: UILabel!
    
    weak var gameSessionController: UIViewController!
    
    var gameWinName: String = "ИГРА ЗАКОНЧЕНА"
    
    private let dataCaretaker = DataCaretaker()

    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
           

            self.gameSessionController.dismiss(animated: true, completion: nil)
            Game.shared.game = nil
           // print("Кол-во использованнных подсказок: \(Game.shared.game!.promtUseCount)")
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if Game.shared.shuffleQuestions {
//            ShuffleQuestionsLabel.text = "Да"
//        } else {
//            ShuffleQuestionsLabel.text = "Нет"
//        }
        
        //Game.shared.game!.randomQuestions = Game.shared.game!.randomQuestionsF()
        Game.shared.game!.promtUseCount = Game.shared.game!.promtUseCountF()
      //  Game.shared.game!.randomQuestionsString = Game.shared.game!.randomQuestionsStringF()
        
        
        GameOverLabel.text = gameWinName
        GamePrizeLabel.text = String(Game.shared.game!.prizeCount) + " рублей"
        RightAnswerCountLabel.text = "правильных ответов " + String(Game.shared.game!.rightAnswerCount)
        AllAnswersCountLabel.text = "всего вопросов " + String(Game.shared.questions!.count)
        if Game.shared.game!.peopleHelpUse { HelpPeopleUseLabel.textColor = .systemYellow }
        if Game.shared.game!.callToFriendUse { CallToFriendUseLabel.textColor = .systemYellow }
        if Game.shared.game!.fiftyFiftyUse { FiftyFiftyUseLabel.textColor = .systemYellow }
        ShuffleQuestionsLabel.text = Game.shared.game!.randomQuestionsStringF()
        
     
//                if Game.shared.shufflePosition == 1 {
//                    ShuffleQuestionsLabel.text = "да" }
//                else {
//                    ShuffleQuestionsLabel.text = "нет" }
   
      //  ShuffleQuestionsLabel.text =   Game.shared.game!.randomQuestionsStringF()

        
        Game.shared.results?.append(Game.shared.game!)
        self.dataCaretaker.saveResults(results: Game.shared.results!)
        // Game.shared.saveGameResults(newGame:  Game.shared.game!)
        
    }
    

}
