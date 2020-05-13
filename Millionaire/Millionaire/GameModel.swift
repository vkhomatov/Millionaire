//
//  GameModel.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 22.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

//import Foundation
import UIKit

final class Game {
    
    static let shared = Game()
    
    private init() { }
    
    //цена первого вопроса
    let firstAnswerCost = 100
    
    var game: GameSession?
    
    var shufflePosition: Int {
        get {
            let userDefaultsGet = UserDefaults.standard
            guard let shuffle = userDefaultsGet.object(forKey: "SHAFFLE") as? Int else {
                print("Ключ SHAFFLE в UserDefaults не найден")
                return 0 }
            print("shufflePositionGet \(shuffle)")
            return shuffle
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "SHAFFLE")
            print("shufflePositionSet \(newValue)")
            
        }
    }
    
    
    var timerPosition: Int {
        get {
            let userDefaultsGet = UserDefaults.standard
            guard let timer = userDefaultsGet.object(forKey: "TIMER") as? Int else {
                print("Ключ TIMER в UserDefaults не найден")
                return 0 }
            print("timerPositionGet \(timer)")
            return timer
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TIMER")
            print("timerPositionSet \(newValue)")
            
        }
    }
   
    
    // массив вопросов, сохраняем в UD и загружаем из UD
    var questions : [Question]?
    
    //массив результатов игр, сохраняем в UD и загружаем из UD
    var results : [Result]?
    
    // функция загрузки вшитых в приложение вопросов, если пользователь стер все вопросы из базы
    func getQuestions() {
      
        let biq = builtinQuestions()

        questions = [Question]()
    
        questions!.append(Question(question: biq.question1, rightAnswer: biq.rightAnswer1, wrongAnswer1: biq.wrongAnswer1_1, wrongAnsver2:  biq.wrongAnswer1_2, wrongAnsver3:  biq.wrongAnswer1_3))
        questions!.append(Question(question: biq.question2, rightAnswer: biq.rightAnswer2, wrongAnswer1: biq.wrongAnswer2_1, wrongAnsver2:  biq.wrongAnswer2_2, wrongAnsver3:  biq.wrongAnswer2_3))
        questions!.append(Question(question: biq.question3, rightAnswer: biq.rightAnswer3, wrongAnswer1: biq.wrongAnswer3_1, wrongAnsver2:  biq.wrongAnswer3_2, wrongAnsver3:  biq.wrongAnswer3_3))
        questions!.append(Question(question: biq.question4, rightAnswer: biq.rightAnswer4, wrongAnswer1: biq.wrongAnswer4_1, wrongAnsver2:  biq.wrongAnswer4_2, wrongAnsver3:  biq.wrongAnswer4_3))
        questions!.append(Question(question: biq.question5, rightAnswer: biq.rightAnswer5, wrongAnswer1: biq.wrongAnswer5_1, wrongAnsver2:  biq.wrongAnswer5_2, wrongAnsver3:  biq.wrongAnswer5_3))
        questions!.append(Question(question: biq.question6, rightAnswer: biq.rightAnswer6, wrongAnswer1: biq.wrongAnswer6_1, wrongAnsver2:  biq.wrongAnswer6_2, wrongAnsver3:  biq.wrongAnswer6_3))
        questions!.append(Question(question: biq.question7, rightAnswer: biq.rightAnswer7, wrongAnswer1: biq.wrongAnswer7_1, wrongAnsver2:  biq.wrongAnswer7_2, wrongAnsver3:  biq.wrongAnswer7_3))
        questions!.append(Question(question: biq.question8, rightAnswer: biq.rightAnswer8, wrongAnswer1: biq.wrongAnswer8_1, wrongAnsver2:  biq.wrongAnswer8_2, wrongAnsver3:  biq.wrongAnswer8_3))
        questions!.append(Question(question: biq.question9, rightAnswer: biq.rightAnswer9, wrongAnswer1: biq.wrongAnswer9_1, wrongAnsver2:  biq.wrongAnswer9_2, wrongAnsver3:  biq.wrongAnswer9_3))
        questions!.append(Question(question: biq.question10, rightAnswer: biq.rightAnswer10, wrongAnswer1: biq.wrongAnswer10_1, wrongAnsver2:  biq.wrongAnswer10_2, wrongAnsver3:  biq.wrongAnswer10_3))
        
    }
    
    
}

// структура вопроса
struct Question: Equatable, Codable {
    
    var question : String?
    var rightAnswer : String?
    var wrongAnswer1 : String?
    var wrongAnsver2 : String?
    var wrongAnsver3 : String?
    
}


// структура с набором вопросов по умолчанию
struct builtinQuestions {
    
    let question1 = "Какая библиотека нужна для создания пользовательского интерфейса?"
    let rightAnswer1 = "UIKit"
    let wrongAnswer1_1 = "GameplayKit"
    let wrongAnswer1_2 = "UI"
    let wrongAnswer1_3 = "SpriteKit"
    
    let question2 = "Где правильно создан массив со строками?"
    let rightAnswer2 = "var words = [String]()"
    let wrongAnswer2_1 = "var words = [String]"
    let wrongAnswer2_2 = "var words : String = ()"
    let wrongAnswer2_3 = "var words = [](String)"
    
    let question3 = "Где неправильно добавляются элементы в массив?"
    let rightAnswer3 = "Все варианты верные"
    let wrongAnswer3_1 = "digits += [8.23, 5, 2.96]"
    let wrongAnswer3_2 = "digits[0] = 0.5"
    let wrongAnswer3_3 = "digits.insert (9.4, at: 1)"
    
    let question4 = "Чем отличаются операторы break и continue в цикле?"
    let rightAnswer4 = "Continue - пропускает, break - выходит"
    let wrongAnswer4_1 = "У них нет никакой разницы"
    let wrongAnswer4_2 = "Они используются в разных циклах"
    let wrongAnswer4_3 = "Break - пропускает, continue - выходит"
    
    let question5 = "Сколько циклов существует в Swift?"
    let rightAnswer5 = "3"
    let wrongAnswer5_1 = "2"
    let wrongAnswer5_2 = "4"
    let wrongAnswer5_3 = "5"
    
    let question6 = "Какая программа используется для Swift?"
    let rightAnswer6 = "Xcode"
    let wrongAnswer6_1 = "Xamarin Studio"
    let wrongAnswer6_2 = "Visual Studio"
    let wrongAnswer6_3 = "Любая IDE подойдет"
    
    let question7 = "Где правильно создана переменная?"
    let rightAnswer7 = "var x : Float = 2.56"
    let wrongAnswer7_1 = "float x = 2.56"
    let wrongAnswer7_2 = "x = 2.56"
    let wrongAnswer7_3 = "var x = 2.56 : Float"
    
    let question8 = "Какая библиотека используется для создания игр?"
    let rightAnswer8 = "GameplayKit и SpriteKit"
    let wrongAnswer8_1 = "SpriteKit"
    let wrongAnswer8_2 = "GameplayKit"
    let wrongAnswer8_3 = "UIKit"
    
    let question9 = "Что можно создавать на Swift?"
    let rightAnswer9 = "Игры и ПО для всей продукции Apple"
    let wrongAnswer9_1 = "Игры и ПО для всей продукции Apple"
    let wrongAnswer9_2 = "Приложения для iPhone и iPad"
    let wrongAnswer9_3 = "Игры для компьютеров (Mac)"
    
    let question10 = "Что устраняют generics?"
    let rightAnswer10 = "Проблему дублирования кода"
    let wrongAnswer10_1 = "Проблему вывода данных"
    let wrongAnswer10_2 = "Проблему ввода"
    let wrongAnswer10_3 = "Проблему приведения типов"
    
}
