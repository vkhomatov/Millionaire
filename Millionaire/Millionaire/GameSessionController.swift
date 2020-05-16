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
    
    private let dataCaretaker = DataCaretaker()
    private var shuffleStrategy: ShuffleQuestionsStrategy = yesShuffle()
    private var noshuffleStrategy: NoShuffleQuestionsStrategy = noShuffle()
    private let gamePromptsFacade = GamePromptsFacade()
    private var closureObservable = ClosureObservable(gameTime: 0)
    
    private var answerButtons = [UIButton]()
    
    // обработка нажатия на кнопки ответов на вопрос
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
    
    // обработка нажатия на кнопки подсказок
    @IBAction func PromtButtonPush(_ sender: UIButton) {
        
        if let answer = sender.currentTitle {
            switch answer {
                
            case PeopleHelpButton.titleLabel!.text:
                Game.shared.game!.result.peopleHelpUse = true
                gamePromptsFacade.PeopleAndFriendHelpPrompt(people: true, for: answerButtons)
                
            case CallToFriendButton.titleLabel!.text:
                Game.shared.game!.result.callToFriendUse = true
                gamePromptsFacade.PeopleAndFriendHelpPrompt(people: false, for: answerButtons)
                
            case FiftyFiftyButton.titleLabel!.text:
                Game.shared.game!.result.fiftyFiftyUse = true
                gamePromptsFacade.FiftyFiftyPrompt(promptCount: 2, for: answerButtons)
                
            default:
                break
            }
        }
        
        // выключаем кнопки подсказок - блокируем возможность использование нескольких подсказок для одного вопроса
        PeopleHelpButton.isEnabled = false
        FiftyFiftyButton.isEnabled = false
        CallToFriendButton.isEnabled = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // создание объекта GameSession и получение времени начала игры
        Game.shared.game = GameSession(answerCost: Game.shared.firstAnswerCost)
        if Game.shared.game != nil {
            Game.shared.game!.result.dateGame = Game.shared.game!.dateGameF()
        } else {
            print("Объект GameSession не был создан")
            return
        }
        
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
        
        // создание массива из кнопок ответов
        answerButtons.append(Answer1Button)
        answerButtons.append(Answer2Button)
        answerButtons.append(Answer3Button)
        answerButtons.append(Answer4Button)
        
        // загрузка первого вопроса
        nextQuestion()
        Game.shared.game!.firstQuestion = false
        
        // передача параметра через замыкание
        Game.shared.game!.onGameEnd =  { result in
            print("Передача параметра через замыкание, правильных ответов: \(result)")
        }
        
        // установка обсервера на параметр "время до окончания игры"
        closureObservable = ClosureObservable(gameTime: Game.shared.game!.timeLeft)
        closureObservable.observe { newValue in
            print("Обсервер, время до конца игры: \(newValue)")
        }
        
    }
    
    // настройка интерфейса для вопроса
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
        
        // подсчет результатов игры; если вопрос первый, то не считаем
        if Game.shared.game!.firstQuestion == false {
            Game.shared.game!.result.questionCount += 1
            Game.shared.game!.result.answerCost = Game.shared.game!.result.answerCost*2
            Game.shared.game!.result.rightAnswerCount += 1
            Game.shared.game!.result.prizeCount = Game.shared.game!.prizeCountF()
        }
        
        if Game.shared.questions != nil && Game.shared.game!.result.questionCount < Game.shared.questions!.count {
            
            // перемешивание кнопок для того чтобы правильный ответ был каждый запуск игры в новой позиции
            answerButtons.shuffle()
            
            // заполненние элементов интерфейса данными
            guard let screenData = Game.shared.game!.setScreenQuestionData() else { return }
            
            QuestionLabel.text = screenData.question.question
            answerButtons[0].setTitle(screenData.question.rigthAnswer, for: .normal)
            answerButtons[1].setTitle(screenData.question.wrongAnswer1, for: .normal)
            answerButtons[2].setTitle(screenData.question.wrongAnswer2, for: .normal)
            answerButtons[3].setTitle(screenData.question.wrongAnswer3, for: .normal)
            
            QuestionCountLabel.text = screenData.session.questionCount
            AnswerCostLabel.text = screenData.session.questionCost
            RightAswersLabel.text = screenData.session.rightAnswers
            PrizeCountLabel.text = screenData.session.prizeCount
            
        } else {
            performSegue(withIdentifier: "EndGameControllerSegue", sender: nil)
        }
        
    }
    
    
    // таймер отсчета времени игры
    @objc func onTimer()
    {
        Game.shared.game!.timeLeft -= 1
        closureObservable.gameTime = Game.shared.game!.timeLeft
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

// заполненние элементов интерфейса данными
//            QuestionLabel.text = Game.shared.questions![Game.shared.game!.result.questionCount].question
//            answerButtons[0].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].rightAnswer, for: .normal)
//            answerButtons[1].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnswer1, for: .normal)
//            answerButtons[2].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver2, for: .normal)
//            answerButtons[3].setTitle(Game.shared.questions![Game.shared.game!.result.questionCount].wrongAnsver3, for: .normal)
//
//            QuestionCountLabel.text = "ВОПРОС " + String(Game.shared.game!.result.questionCount + 1) + " из " + String(Game.shared.questions!.count)
//            AnswerCostLabel.text = "На кону " + String(Game.shared.game!.result.answerCost) + " рублей"
//            RightAswersLabel.text = "правильных ответов " + String(Game.shared.game!.result.questionCount)
//            PrizeCountLabel.text = "общий выигрыш  " + String(Game.shared.game!.result.prizeCount) + " рублей"
