//
//  DataCaretaker.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 25.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import Foundation

//typealias Memento = Data

final class DataCaretaker {
   
   private let encoder = JSONEncoder()
   private let decoder = JSONDecoder()
   
   private let key1 = "questions"
   private let key2 = "results"
   
   // загрузка/выгрузка базы с вопросами
    
   func saveQuestions(questions: [Question]) {
       do {
        let data = try self.encoder.encode(questions)
           UserDefaults.standard.set(data, forKey: key1)
       } catch {
           print(error)
       }
   }
   
    func retrieveQuestions() -> [Question] {
       guard let data = UserDefaults.standard.data(forKey: key1) else {
           print("Не могу загрузить результаты игр")
           return []
       }
       do {
        return try self.decoder.decode([Question].self, from: data)
       } catch {
           print(error)
           return []
       }
   }
    
    
    // загрузка/выгрузка результатов игры
    
    func saveResults(results: [GameSession]) {
        do {
         let data = try self.encoder.encode(results)
            UserDefaults.standard.set(data, forKey: key2)
        } catch {
            print(error)
        }
    }
    
    func retrieveResults() -> [GameSession] {
        guard let data = UserDefaults.standard.data(forKey: key2) else {
            print("Не могу загрузить результаты игр")
            return []
        }
        do {
            return try self.decoder.decode([GameSession].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
     
    // загрузка/ запись состояния переключателя порядка вопросов
    
//    func saveUserSetup() {
//       // guard let userDefaults = UserDefaults.standard.data
//             UserDefaults.standard.set(Game.shared.shuffleQuestions, forKey: "SHAFFLE")
//             print("saveUserSetup \(String(describing: Game.shared.shuffleQuestions) )")
//            // print("readUserSetup \(String(describing: readUserSetup()) )")
//        }
//        
        
    //    guard let data = UserDefaults.standard.data(forKey: key2) else {
    //               print("Не могу загрузить результаты игр")
    //               return []
    //           }
        
//        // Чтение пометки о существовании записи из User Defaults
//    func readUserSetup() {
//            // let userDefaultsGet = UserDefaults.standard
//            Game.shared.shuffleQuestions = (UserDefaults.standard.object(forKey: "SHAFFLE") as? Bool)
//             print("readUserSetup \(String(describing: Game.shared.shuffleQuestions) )")
//            // return result
//        }
    
    
    
    
    
    
}
