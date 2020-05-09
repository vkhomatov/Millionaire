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
    private var countQuestion: Int  = 0
    
    // функция вроверки на правильность ввода и сохранения нового вопроса в базе ( вынести в модель и использовать Delegate )
    func saveNewQuestion(question : String?, rightAnswer : String?, wrongAnswer1 : String?, wrongAnswer2 : String?, wrongAnswer3 : String?) -> Int {
        
        if question == "" { return 1 }
        if rightAnswer == "" { return 2 }
        if wrongAnswer1 == "" { return 3 }
        if wrongAnswer2 == "" { return 4 }
        if wrongAnswer3 == "" { return 5 }
        
        for count in 0...Game.shared.questions!.count-1 {
            if Game.shared.questions![count].question == question {
                self.countQuestion = count
                return 6
            }
        }
        
        var newQuestion = Question()
        newQuestion.question = question
        newQuestion.rightAnswer = rightAnswer
        newQuestion.wrongAnswer1 = wrongAnswer1
        newQuestion.wrongAnsver2 = wrongAnswer2
        newQuestion.wrongAnsver3 = wrongAnswer3
        
        if Game.shared.questions != nil {
            Game.shared.questions?.append(newQuestion)
            dataCaretaker.saveQuestions(questions: Game.shared.questions!)
        } else { return 7 }
        
        return 0
        
    }
    
    @IBAction func AddQuestionButton(_ sender: UIButton) {
        
        if Game.shared.questions == nil {
            print("Ошибка загрузки базы с вопросами")
            return }
        
        switch saveNewQuestion(question: QuestionTextField.text, rightAnswer: RightAnswerTextField.text, wrongAnswer1: WrongAnswer1TextField.text, wrongAnswer2: WrongAnswer2TextField.text, wrongAnswer3: WrongAnswer3TextField.text) {
        case 0:
            print("Новый вопрос сохранен в базе")
            self.view.endEditing(true)
            QuestionsTableView.reloadData()
            let indexPath = IndexPath(row: Game.shared.questions!.count-1, section: 0)
            DispatchQueue.main.async { self.QuestionsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true) }
        case 1:
            QuestionTextField.placeholder = "Введите текст вопроса"
            QuestionTextField.becomeFirstResponder()
        case 2:
            RightAnswerTextField.placeholder = "Введите правильный ответ"
            RightAnswerTextField.becomeFirstResponder()
        case 3:
            WrongAnswer1TextField.placeholder = "Введите неправильный ответ №1"
            WrongAnswer1TextField.becomeFirstResponder()
        case 4:
            WrongAnswer2TextField.placeholder = "Введите неправильный ответ №2"
            WrongAnswer2TextField.becomeFirstResponder()
        case 5:
            WrongAnswer3TextField.placeholder = "Введите неправильный ответ №3"
            WrongAnswer3TextField.becomeFirstResponder()
        case 6:
            QuestionTextField.placeholder = "Вопрос уже существует в базе"
            QuestionTextField.text = ""
            QuestionTextField.becomeFirstResponder()
            let indexPath = IndexPath(row: countQuestion, section: 0)
            DispatchQueue.main.async { self.QuestionsTableView.scrollToRow(at: indexPath, at: .none, animated: true) }
        case 7:
            print("Объект вопросы не был создан")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionsTableView.dataSource = self
        QuestionsTableView.delegate = self
        
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if Game.shared.questions != nil
            {
                Game.shared.questions!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                dataCaretaker.saveQuestions(questions: Game.shared.questions!)
                
            }
        }
    }
    
// Отключает удаление встроенных вопросов
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//
//        if indexPath.row < 10 {
//            return UITableViewCell.EditingStyle.none
//        } else {
//            return UITableViewCell.EditingStyle.delete
//        }
//
//    }
//
    
    
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
