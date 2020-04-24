//
//  GameController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class GameController: UIViewController {

    @IBAction func ShuffleQuestionsSwith(_ sender: UISwitch) {
        
        if sender.isOn {
            ShaffleQuestionsLabel.textColor = .systemGreen
            Game.shared.shuffleQuestions = true
            Game.shared.getQuestions(shuffle: Game.shared.shuffleQuestions)

        } else {
            ShaffleQuestionsLabel.textColor = .systemGray5
            Game.shared.shuffleQuestions = false
            Game.shared.getQuestions(shuffle: Game.shared.shuffleQuestions)

        }
        
    }
    
    @IBOutlet weak var ShaffleQuestionsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.shared.getQuestions(shuffle: Game.shared.shuffleQuestions)
        Game.shared.getGameResults()

        
    }
    
    

}
