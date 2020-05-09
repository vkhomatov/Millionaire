//
//  GameSessionController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

//protocol GameSessionDelegate: class {
//   func nextQuestion(withResult result: Int)
//}


protocol ShuffleQuestionsStrategy {
    func shuffle()
}

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
    
    @IBOutlet weak var ToEndOfGameLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PeopleHelpButton: UIButton!
    @IBOutlet weak var CallToFriendButton: UIButton!
    @IBOutlet weak var FiftyFiftyButton: UIButton!
    
    
    
    // !!!!!!!!!!!! ПЕРЕНЕСТИ В МОДЕЛЬ ВЕСЬ ФУНКЦИОНАЛ ИГРОВОЙ СЕССИИ, ИСПОЛЬЗОВАТЬ DELEGATE !!!!!!!!!!!!!!
    
    var shuffleStrategy: ShuffleQuestionsStrategy = yesShuffle()
    
    private var gameSession = GameSession(answerCost: Game.shared.firstAnswerCost)
    
    private var answerButtons = [UIButton]()
    
    //  private var gameWin: Bool = false
    
    private var timer:Timer?
    var timeLeft = Game.shared.questions!.count * 60
    
    
    @IBAction func AnswerButtonPush(_ sender: UIButton) {
        
        if Game.shared.questions == nil || Game.shared.game == nil {
            print("База вопросов пуста или сеанс игры не создан")
            return }
        
        if let answer = sender.currentTitle {
            
            //перенести функционал в модель, подумать как лучше это сделать
            
            switch answer {
                
            case Game.shared.questions![Game.shared.game!.result.questionCount-1].rightAnswer:
                
                //  print("Вопрос № \(Game.shared.game!.questionCount), правильный ответ: \(String( Game.shared.questions![Game.shared.game!.questionCount-1].rightAnswer!))")
                
                if  Game.shared.game!.result.questionCount == Game.shared.questions!.count {
                    Game.shared.game!.result.rightAnswerCount += 1
                    
                    // gameWin = true
                    
                    performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
                    //     print("Игра закончена, Вы победили!")
                    
                } else {
                    nextQuestion()
                    Game.shared.game!.result.rightAnswerCount += 1
                }
                
            //
            default:
                // print("Неправильный ответ, правильный ответ: \(String(describing: Game.shared.questions![Game.shared.game!.questionCount-1].rightAnswer))")
                
                Game.shared.game!.result.prizeCount = (Game.shared.game!.result.prizeCount - Game.shared.firstAnswerCost) / 2
                performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
            }
        }
    }
    
    //
    @IBAction func PromtButtonPush(_ sender: UIButton) {
        if let answer = sender.currentTitle {
            switch answer {
                
            case PeopleHelpButton.titleLabel!.text:
                Game.shared.game!.result.peopleHelpUse = true
                PeopleAndFriendHelpPrompt(people: true)
                
            case CallToFriendButton.titleLabel!.text:
                Game.shared.game!.result.callToFriendUse = true
                PeopleAndFriendHelpPrompt(people: false)
                
            case FiftyFiftyButton.titleLabel!.text:
                Game.shared.game!.result.fiftyFiftyUse = true
                FiftyFiftyPrompt(promptCount: 2)
                
            default:
                break
            }
        }
        
    }
    
    //перенести функционал в модель
    func FiftyFiftyPrompt(promptCount: Int) {
        
        // выключение всех кнопок после
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.result.questionCount-1]
        //  print("Текущий вопрос \(currentQuestion.question!)")
        var wrongQuestionsButtons = answerButtons
        
        for button in 0...answerButtons.count-1 {
            if answerButtons[button].titleLabel?.text == currentQuestion.rightAnswer {
                wrongQuestionsButtons.remove(at: button)
                //  print("Правильный ответ \(String(answerButtons[button].titleLabel!.text!)) удален из списка блокировки")
            }
        }
        
        for _ in 1...promptCount {
            let number = Int.random(in: 0 ... wrongQuestionsButtons.count-1)
            wrongQuestionsButtons[number].isEnabled = false
            wrongQuestionsButtons.remove(at: number)
        }
        
    }
    
    // перенести функционал в модель
    func PeopleAndFriendHelpPrompt(people: Bool) {
        
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.result.questionCount-1]
        var wrongQuestionsButtons = answerButtons
        
        
        if people  {
         
            for button in 0...wrongQuestionsButtons.count-1 {
                if answerButtons[button].titleLabel?.text != currentQuestion.rightAnswer && wrongQuestionsButtons.count > 2 {
                    wrongQuestionsButtons.remove(at: button)
                }
            }
            
        }
        
        wrongQuestionsButtons.randomElement()?.titleLabel?.textColor = .systemGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // если пользователь стер все вопросы восстанавливаем вопросы из встроенной базы
        if Game.shared.questions?.count == 0 || Game.shared.questions == nil {
            Game.shared.getQuestions()
        }
        
        Game.shared.game = gameSession
        Game.shared.game!.result.dateGame = Game.shared.game!.dateGameF()
        
        
        // перенести функционал в модель
        if Game.shared.shufflePosition == 1 {
            self.shuffleStrategy.shuffle()
        }
        
        if Game.shared.timerPosition == 1 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            ToEndOfGameLabel.isHidden = false
            TimeLabel.isHidden = false
        }
        
        answerButtons.append(Answer1Button)
        answerButtons.append(Answer2Button)
        answerButtons.append(Answer3Button)
        answerButtons.append(Answer4Button)
        nextQuestion()
        
    }
    
    // перенести функционал в модель
    func nextQuestion() {
        
        // включение кнопок с вопросами после использования подсказок
        for button in 0...answerButtons.count-1 {
            answerButtons[button].isEnabled = true
            answerButtons[button].titleLabel?.textColor = .systemBlue
        }
        
        // включение кнопок с неиспользованными подсказками
        PeopleHelpButton.isEnabled = !Game.shared.game!.result.peopleHelpUse
        CallToFriendButton.isEnabled = !Game.shared.game!.result.callToFriendUse
        FiftyFiftyButton.isEnabled = !Game.shared.game!.result.fiftyFiftyUse
        
        answerButtons.shuffle()
        
        if Game.shared.questions != nil && Game.shared.game!.result.questionCount <= Game.shared.questions!.count {
            
            self.QuestionLabel.text = Game.shared.questions![Game.shared.game!.result.questionCount].question
            self.answerButtons[0].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].rightAnswer, for: .normal)
            self.answerButtons[1].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnswer1, for: .normal)
            self.answerButtons[2].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver2, for: .normal)
            self.answerButtons[3].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver3, for: .normal)
            
            if Game.shared.game!.result.questionCount < Game.shared.questions!.count {
                
                QuestionCountLabel.text = "ВОПРОС " + String(Game.shared.game!.result.questionCount + 1) + " из " + String(Game.shared.questions!.count)
                AnswerCostLabel.text = "На кону " + String(Game.shared.game!.result.answerCost) + " рублей"
                RightAswersLabel.text = "правильных ответов " + String(Game.shared.game!.result.questionCount)
                PrizeCountLabel.text = "общий выигрыш  " + String(Game.shared.game!.result.prizeCount) + " рублей"
                
                Game.shared.game!.result.prizeCount += Game.shared.game!.result.answerCost
                Game.shared.game!.result.questionCount += 1
                Game.shared.game!.result.answerCost = Game.shared.game!.result.answerCost*2
                
            }
            
        }
        
    }
    
    
    // перенести функционал в модель
    @objc func onTimer()
    {
        timeLeft -= 1
        TimeLabel.text = timeString(time: TimeInterval(timeLeft))
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            Game.shared.game!.result.prizeCount = (Game.shared.game!.result.prizeCount - Game.shared.firstAnswerCost) / 2
            performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
}






// Демонстрацию нового UIViewController
//  let endGameController: UIViewController = (self.storyboard?.instantiateViewController(identifier: "EndGameControllerSB"))!
//  self.present(endGameController, animated: true, completion: nil)
//  Game.shared.game!.prizeCount = (Game.shared.game!.prizeCount - Game.shared.firstAnswerCost) / 2

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "EndGameControllerSegue" {
//
//            guard let gameController = segue.source as? GameSessionController else { return }
//            guard let endGameController = segue.destination as? EndGameController else { return }
//
//          //  endGameController.gameSessionController = gameController
//
//            if gameWin {
//                endGameController.gameWinName = "ВЫ ВЫИГРАЛИ ИГРУ!"
//
//            }
//
//        }
//    }
//
//    @IBAction func returnToGameSession(unwindSegue: UIStoryboardSegue) {
//
//    }
