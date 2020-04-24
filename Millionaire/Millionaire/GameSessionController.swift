//
//  GameSessionController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class GameSessionController: UIViewController {
    
    @IBOutlet weak var QuestionCountLabel: UILabel!
    @IBOutlet weak var AnswerCostLabel: UILabel!
    @IBOutlet weak var RightAswersLabel: UILabel!
    @IBOutlet weak var PrizeCountLabel: UILabel!
    
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var Answer1Button: UIButton!
    @IBOutlet weak var Answer2Button: UIButton!
    @IBOutlet weak var Answer3Button: UIButton!
    @IBOutlet weak var Answer4Button: UIButton!
    
    @IBOutlet weak var PeopleHelpButton: UIButton!
    @IBOutlet weak var CallToFriendButton: UIButton!
    @IBOutlet weak var FiftyFiftyButton: UIButton!
    
    private var gameSession = GameSession(answerCost: Game.shared.firstAnswerCost, randomQuestions: false, rightAnswerCount: 0, prizeCount: 0, peopleHelpUse: false, callToFriendUse: false, fiftyFiftyUse: false)
    
    private var answerButtons = [UIButton]()
    
    private var gameWin: Bool = false
    
    @IBAction func AnswerButtonPush(_ sender: UIButton) {
        
        if Game.shared.questions == nil || Game.shared.game == nil {
            print("База вопросов пуста или сеанс игры не создан")
            return }
        
        if let answer = sender.currentTitle {
            switch answer {
            case Game.shared.questions![Game.shared.game!.questionCount-1].rightAnswer:
                
                print("Вопрос № \(Game.shared.game!.questionCount), правильный ответ: \(String( Game.shared.questions![Game.shared.game!.questionCount-1].rightAnswer!))")
                
                if  Game.shared.game!.questionCount == Game.shared.questions!.count {
                    Game.shared.game!.rightAnswerCount += 1
                    
                    gameWin = true
                    
                    performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
                    print("Игра закончена, Вы победили!")
                    
                } else {
                    nextQuestion()
                    Game.shared.game!.rightAnswerCount += 1
                }
                
            default:
                print("Неправильный ответ, правильный ответ: \(String(describing: Game.shared.questions![Game.shared.game!.questionCount-1].rightAnswer))")
                
                Game.shared.game!.prizeCount = (Game.shared.game!.prizeCount - Game.shared.firstAnswerCost) / 2
                performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
            }
        }
    }
    
    @IBAction func PromtButtonPush(_ sender: UIButton) {
        if let answer = sender.currentTitle {
            switch answer {
                
            case PeopleHelpButton.titleLabel!.text:
                Game.shared.game!.peopleHelpUse = true
                PeopleHelp(people: true)
                
            case CallToFriendButton.titleLabel!.text:
                Game.shared.game!.callToFriendUse = true
                PeopleHelp(people: false)

            case FiftyFiftyButton.titleLabel!.text:
                Game.shared.game!.fiftyFiftyUse = true
                UsePrompt(promptCount: 2)
                
            default:
                break
            }
        }
        
    }
    
    //перенести функционал в модель
    func UsePrompt(promptCount: Int) {
        
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.questionCount-1]
        print("Текущий вопрос \(currentQuestion.question!)")
        var wrongQuestionsButtons = answerButtons
        
        for button in 0...answerButtons.count-1 {
            if answerButtons[button].titleLabel?.text == currentQuestion.rightAnswer {
                wrongQuestionsButtons.remove(at: button)
                print("Правильный ответ \(String(answerButtons[button].titleLabel!.text!)) удален из списка блокировки")
            }
        }
        
        for _ in 1...promptCount {
            let number = Int.random(in: 0 ... wrongQuestionsButtons.count-1)
            wrongQuestionsButtons[number].isEnabled = false
            wrongQuestionsButtons.remove(at: number)
        }
        
    }
    
    // перенести функционал в модель
    func PeopleHelp(people: Bool) {
        
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.questionCount-1]
        var wrongQuestionsButtons = answerButtons
        
        if people  {
            for button in 0...answerButtons.count-1 {
                if answerButtons[button].titleLabel?.text != currentQuestion.rightAnswer && wrongQuestionsButtons.count > 2 {
                        wrongQuestionsButtons.remove(at: button)
                }
            }
        }
        
        wrongQuestionsButtons.randomElement()?.titleLabel?.textColor = .systemGreen
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.shared.game = gameSession
        answerButtons.append(Answer1Button)
        answerButtons.append(Answer2Button)
        answerButtons.append(Answer3Button)
        answerButtons.append(Answer4Button)
        nextQuestion()
        
    }
    
    
    func nextQuestion() {
        
        // включение кнопок с вопросами после использования подсказок
        for button in 0...answerButtons.count-1 {
            answerButtons[button].isEnabled = true
            answerButtons[button].titleLabel?.textColor = .systemBlue
        }
        
        // включение не использованных подсказок
        PeopleHelpButton.isEnabled = !Game.shared.game!.peopleHelpUse
        CallToFriendButton.isEnabled = !Game.shared.game!.callToFriendUse
        FiftyFiftyButton.isEnabled = !Game.shared.game!.fiftyFiftyUse

        answerButtons.shuffle()
        
        if Game.shared.questions != nil && Game.shared.game!.questionCount <= Game.shared.questions!.count {
            
            self.QuestionLabel.text = Game.shared.questions![Game.shared.game!.questionCount].question
            self.answerButtons[0].setTitle(Game.shared.questions![Game.shared.game!.questionCount].rightAnswer, for: .normal)
            self.answerButtons[1].setTitle(Game.shared.questions![Game.shared.game!.questionCount].wrongAnswer1, for: .normal)
            self.answerButtons[2].setTitle(Game.shared.questions![Game.shared.game!.questionCount].wrongAnsver2, for: .normal)
            self.answerButtons[3].setTitle(Game.shared.questions![Game.shared.game!.questionCount].wrongAnsver3, for: .normal)
            
            if Game.shared.game!.questionCount < Game.shared.questions!.count {
                
                QuestionCountLabel.text = "ВОПРОС " + String(Game.shared.game!.questionCount + 1) + " из " + String(Game.shared.questions!.count)
                AnswerCostLabel.text = "На кону " + String(Game.shared.game!.answerCost) + " рублей"
                RightAswersLabel.text = "правильных ответов " + String(Game.shared.game!.questionCount)
                PrizeCountLabel.text = "общий выигрыш  " + String(Game.shared.game!.prizeCount) + " рублей"
                
                Game.shared.game!.prizeCount += Game.shared.game!.answerCost
                Game.shared.game!.questionCount += 1
                Game.shared.game!.answerCost = Game.shared.game!.answerCost*2
                
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EndGameControllerSegue" {
            
            guard let gameController = segue.source as? GameSessionController else { return }
            guard let endGameController = segue.destination as? EndGameController else { return }
            
            endGameController.gameSessionController = gameController
            
            if gameWin {
                endGameController.gameWinName = "ВЫ ВЫИГРАЛИ ИГРУ!"
                
            }
            
        }
    }
    
}


// Демонстрацию нового UIViewController
//  let endGameController: UIViewController = (self.storyboard?.instantiateViewController(identifier: "EndGameControllerSB"))!
//  self.present(endGameController, animated: true, completion: nil)
//  Game.shared.game!.prizeCount = (Game.shared.game!.prizeCount - Game.shared.firstAnswerCost) / 2

