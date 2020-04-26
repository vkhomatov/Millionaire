//
//  AddQuestionController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class AddQuestionController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var QuestionTextField: UITextField!
    @IBOutlet weak var RightAnswerTextField: UITextField!
    @IBOutlet weak var WrongAnswer1TextField: UITextField!
    @IBOutlet weak var WrongAnswer2TextField: UITextField!
    @IBOutlet weak var WrongAnswer3TextField: UITextField!
    
    @IBOutlet weak var QuestionsTableView: UITableView!
    
    private var newQuestion = Question()
    
    private let dataCaretaker = DataCaretaker()
    
    
    @IBAction func AddQuestionButton(_ sender: UIButton) {
        
        if Game.shared.questions == nil { return  }
        
        //обернуть проверку в функцию
        if QuestionTextField.text == "" { QuestionTextField.placeholder = "Введите текст вопроса"
            return }
        
        newQuestion.question = QuestionTextField.text!
        
        //        let flatQuestions = Game.shared.questions!.compactMap { $0.question }
        //
        //        if flatQuestions.contains(newQuestion.question!) {
        //            QuestionTextField.text = ""
        //            QuestionTextField.placeholder = "Вопрос уже существует в базе"
        //            print("Вопрос \(newQuestion) уже существует в базе")
        //            return }
        
        
        for count in 0...Game.shared.questions!.count-1 {
            if Game.shared.questions![count].question == newQuestion.question {
                QuestionTextField.text = ""
                QuestionTextField.placeholder = "Вопрос уже существует в базе"
                let indexPath = IndexPath(row: count, section: 0)
                
                DispatchQueue.main.async {
                    self.QuestionsTableView.scrollToRow(at: indexPath, at: .none, animated: true)
                    
                }
                return
            }
        }
        
        if RightAnswerTextField.text == "" { RightAnswerTextField.placeholder = "Введите правильный ответ"
            return }
        if WrongAnswer1TextField.text == "" { WrongAnswer1TextField.placeholder = "Введите неправильный ответ №1"
            return }
        if WrongAnswer2TextField.text == "" { WrongAnswer2TextField.placeholder = "Введите неправильный ответ №2"
            return }
        if WrongAnswer3TextField.text == "" { WrongAnswer3TextField.placeholder = "Введите неправильный ответ №3"
            return }
        
        newQuestion.rightAnswer = RightAnswerTextField.text!
        newQuestion.wrongAnswer1 = WrongAnswer1TextField.text!
        newQuestion.wrongAnsver2 = WrongAnswer2TextField.text!
        newQuestion.wrongAnsver3 = WrongAnswer3TextField.text!
        
        if Game.shared.questions != nil {
            Game.shared.questions?.append(newQuestion)
            dataCaretaker.saveQuestions(questions: Game.shared.questions!)
        }
        
        //Game.shared.saveQuestion(newQuestion: newQuestion)
        
        QuestionsTableView.reloadData()
        
        let indexPath = IndexPath(row: Game.shared.questions!.count-1, section: 0)
        
        DispatchQueue.main.async {
            self.QuestionsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionsTableView.dataSource = self
        QuestionsTableView.delegate = self
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count =  Game.shared.questions?.count else  {
            return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QuestionsTableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        
        if Game.shared.questions == nil { return cell }
        
        cell.QuestionNameLabel.text = Game.shared.questions![indexPath.row].question
        
//        if indexPath.row < 10 {
//            cell.
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
           // if Game.shared.questions != nil && indexPath.row > 10
           // {
                Game.shared.questions!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            //}
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if indexPath.row < 10 {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
        
    }
    
    
    
}



//     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//           return 40
//       }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//               return "База вопросов"
//
//       }
