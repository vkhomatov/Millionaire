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
    
    private let dataCaretaker = DataCaretaker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.shared.game!.promtUseCount = Game.shared.game!.promtUseCountF()
        
        GamePrizeLabel.text = String(Game.shared.game!.prizeCount) + " рублей"
        RightAnswerCountLabel.text = "правильных ответов " + String(Game.shared.game!.rightAnswerCount)
        AllAnswersCountLabel.text = "всего вопросов " + String(Game.shared.questions!.count)
        if Game.shared.game!.peopleHelpUse { HelpPeopleUseLabel.textColor = .systemYellow }
        if Game.shared.game!.callToFriendUse { CallToFriendUseLabel.textColor = .systemYellow }
        if Game.shared.game!.fiftyFiftyUse { FiftyFiftyUseLabel.textColor = .systemYellow }
        ShuffleQuestionsLabel.text = Game.shared.game!.randomQuestionsStringF()
        
        if Game.shared.questions!.count == Game.shared.game!.rightAnswerCount {
            GameOverLabel.text = "ВЫ ВЫИГРАЛИ ИГРУ!"
        } else {
            GameOverLabel.text = "ИГРА ЗАКОНЧЕНА"
        }
        
        Game.shared.results?.append(Game.shared.game!)
        self.dataCaretaker.saveResults(results: Game.shared.results!)
        
    }
    
}
