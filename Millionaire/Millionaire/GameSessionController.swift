//
//  GameSessionController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

//protocol GameSessionControllerDelegate: AnyObject {
//    func nextQuestion(labelText: String, buttons: [UIButton])
//}


protocol ShuffleQuestionsStrategy {
    func shuffle()
}

protocol NoShuffleQuestionsStrategy {
    func noshuffle()
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
    
  //  weak var gameDelegate: GameSessionControllerDelegate?

    
    private let dataCaretaker = DataCaretaker()
    private var shuffleStrategy: ShuffleQuestionsStrategy = yesShuffle()
    private var noshuffleStrategy: NoShuffleQuestionsStrategy = noShuffle()

    private var answerButtons = [UIButton]()
    

    @IBAction func AnswerButtonPush(_ sender: UIButton) {
        
        if Game.shared.questions == nil || Game.shared.game == nil {
            print("База вопросов пуста или сеанс игры не создан")
            return }
        
        if let answer = sender.currentTitle {
            switch answer {
            case Game.shared.questions![Game.shared.game!.result.questionCount].rightAnswer:
                nextQuestion()
            default:
                performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
            }
        }
        
    }
    
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
    
    // подсказка 50/50
    func FiftyFiftyPrompt(promptCount: Int) {
        
        // выключение всех кнопок после
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.result.questionCount]
        var wrongQuestionsButtons = answerButtons
        
        for button in 0...answerButtons.count-1 {
            if answerButtons[button].titleLabel?.text == currentQuestion.rightAnswer {
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
    func PeopleAndFriendHelpPrompt(people: Bool) {
        
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
        
        let currentQuestion = Game.shared.questions![Game.shared.game!.result.questionCount]
        var wrongQuestionsButtons = answerButtons
        
        if people  {
            for button in 0...wrongQuestionsButtons.count-1 {
                if answerButtons[button].titleLabel?.text != currentQuestion.rightAnswer && wrongQuestionsButtons.count > 2 && button <= (wrongQuestionsButtons.count-1)  {
                    wrongQuestionsButtons.remove(at: button)
                }
            }
        }
        
        wrongQuestionsButtons.randomElement()?.titleLabel?.textColor = .systemGreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Game.shared.game = GameSession(answerCost: Game.shared.firstAnswerCost)
        Game.shared.game!.result.dateGame = Game.shared.game!.dateGameF()
        
       // self.gameDelegate = self
//        Game.shared.game?.gameDelegate = self
//        Game.shared.game?.gameDelegate?.nextQuestion(withResult: 1)
        
     //   gameDelegate?.nextQuestion(withResult: 111)
        
        // если пользователь стер все вопросы восстанавливаем вопросы из встроенной базы
        if Game.shared.questions?.count == 0 || Game.shared.questions == nil {
            Game.shared.getQuestions()
            self.dataCaretaker.saveQuestions(questions: Game.shared.questions!)
        }
        
        // если включен переключатель перемешать впросы, мешаем используя
        if Game.shared.shufflePosition == 1 {
           self.shuffleStrategy.shuffle()
        } else {
            self.noshuffleStrategy.noshuffle()
        }
        
        // установка таймера если переключатель включен
        if Game.shared.timerPosition == 1 {
            Game.shared.game!.timeLeft = Game.shared.questions!.count * 60
            Game.shared.game!.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
            ToEndOfGameLabel.isHidden = false
            TimeLabel.isHidden = false
        }
        
        answerButtons.append(Answer1Button)
        answerButtons.append(Answer2Button)
        answerButtons.append(Answer3Button)
        answerButtons.append(Answer4Button)
        
        nextQuestion()
        Game.shared.game!.firstQuestion = false
        
        


        
        
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
        
        // перемешивание кнопок для того чтобы правильный ответ был каждый запуск игры в новой позиции
        
        // подсчет результатов игры
        if Game.shared.game!.firstQuestion == false {
            Game.shared.game!.result.questionCount += 1
            Game.shared.game!.result.answerCost = Game.shared.game!.result.answerCost*2
            Game.shared.game!.result.rightAnswerCount += 1
            Game.shared.game!.result.prizeCount = Game.shared.game!.prizeCountF()
        }
        
        
        
        if Game.shared.questions != nil && Game.shared.game!.result.questionCount < Game.shared.questions!.count {
            
            answerButtons.shuffle()
            
     //       gameDelegate?.nextQuestion(labelText: QuestionLabel.text!, buttons: answerButtons)

            
            // заполненние элементов интерфейса данными
            QuestionLabel.text = Game.shared.questions![Game.shared.game!.result.questionCount].question
            answerButtons[0].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].rightAnswer, for: .normal)
            answerButtons[1].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnswer1, for: .normal)
            answerButtons[2].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver2, for: .normal)
            answerButtons[3].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver3, for: .normal)
            
            QuestionCountLabel.text = "ВОПРОС " + String(Game.shared.game!.result.questionCount + 1) + " из " + String(Game.shared.questions!.count)
            AnswerCostLabel.text = "На кону " + String(Game.shared.game!.result.answerCost) + " рублей"
            RightAswersLabel.text = "правильных ответов " + String(Game.shared.game!.result.questionCount)
            PrizeCountLabel.text = "общий выигрыш  " + String(Game.shared.game!.result.prizeCount) + " рублей"
            
        } else {
            performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
        }
        
    }
    
    
    // таймер отсчета времени игры
    @objc func onTimer()
    {
        Game.shared.game!.timeLeft -= 1
        TimeLabel.text = Game.shared.game!.timeString(time: TimeInterval(Game.shared.game!.timeLeft))
        
        if Game.shared.game!.timeLeft <= 0 {
            performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
        }
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
