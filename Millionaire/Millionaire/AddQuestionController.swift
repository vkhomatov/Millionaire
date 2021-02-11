//
//  AddQuestionController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class AddQuestionController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var QuestionTextField: UITextField!
    @IBOutlet weak var RightAnswerTextField: UITextField!
    @IBOutlet weak var WrongAnswer1TextField: UITextField!
    @IBOutlet weak var WrongAnswer2TextField: UITextField!
    @IBOutlet weak var WrongAnswer3TextField: UITextField!
    @IBOutlet weak var QuestionsTableView: UITableView!
        
    private var model = AddQuestionModel()
    
    private var keyboardMinY: CGFloat = 0.0
    
    
    @IBAction func AddQuestionButton(_ sender: UIButton) {
        
        if Game.shared.questions == nil {
            print("Ошибка загрузки базы с вопросами")
            return }
        
        switch model.saveNewQuestion(question: QuestionTextField.text, rightAnswer: RightAnswerTextField.text, wrongAnswer1: WrongAnswer1TextField.text, wrongAnswer2: WrongAnswer2TextField.text, wrongAnswer3: WrongAnswer3TextField.text) {
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
            let indexPath = IndexPath(row: model.countQuestion, section: 0)
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
        
        QuestionTextField.delegate = self
        RightAnswerTextField.delegate = self
        WrongAnswer1TextField.delegate = self
        WrongAnswer2TextField.delegate = self
        WrongAnswer3TextField.delegate = self

        
        Game.shared.questions = model.dataCaretaker.retrieveQuestions()

        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
        
        QuestionTextField.becomeFirstResponder()
        
//
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
      /*  NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (ns) in
      //      self.view.frame.origin.y = -35
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (ns) in
        //    self.view.frame.origin.y = 0
        } */
        
    }
    
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
        self.view.frame.origin.y = 0

    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }
    
//
//    private func calculateKeyboardHeigh(textfield: UITextField){
//
//        if textfield.frame.maxY > keyboardMinY {
//                self.view.frame.origin.y = keyboardMinY - textfield.frame.maxY
//        }
//
//    }
//
//    @objc func adjustForKeyboard(notification: Notification) {
//
//        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
//            let keyboardScreenEndFrame = keyboardValue.cgRectValue
//            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//            self.keyboardMinY = self.view.frame.height - keyboardViewEndFrame.height - 5
//        }
//
//    }
//
    

    
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
                model.dataCaretaker.saveQuestions(questions: Game.shared.questions!)
                
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(#function)
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        
    //    calculateKeyboardHeigh(textfield: textField)
        
//        switch textField {
//        case QuestionTextField:
//            //    textField.placeholder = (textField.text == nil) ? textField.placeholder : "Введите текст вопроса"
//
//              //  RightAnswerTextField.becomeFirstResponder()
//            calculateKeyboardHeigh(textfield: QuestionTextField)
//
//
//        case RightAnswerTextField:
//
//                calculateKeyboardHeigh(textfield: WrongAnswer1TextField)
//            //    WrongAnswer1TextField.becomeFirstResponder()
//
//        case WrongAnswer1TextField:
//
//                calculateKeyboardHeigh(textfield: WrongAnswer2TextField)
//
//        case WrongAnswer2TextField:
//
//                calculateKeyboardHeigh(textfield: WrongAnswer3TextField)
//        case WrongAnswer3TextField: break
//
//
//        default:
//            break
//        }

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print(#function)

        return true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        

    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print(#function)
//        switch textField {
//        case QuestionTextField:
//            //    textField.placeholder = (textField.text == nil) ? textField.placeholder : "Введите текст вопроса"
//
//
//                calculateKeyboardHeigh(textfield: RightAnswerTextField)
//              //  RightAnswerTextField.becomeFirstResponder()
//
//        case RightAnswerTextField:
//
//                calculateKeyboardHeigh(textfield: WrongAnswer1TextField)
//            //    WrongAnswer1TextField.becomeFirstResponder()
//
//        case WrongAnswer1TextField:
//
//                calculateKeyboardHeigh(textfield: WrongAnswer2TextField)
//
//        case WrongAnswer2TextField:
//
//                calculateKeyboardHeigh(textfield: WrongAnswer3TextField)
//        case WrongAnswer3TextField:
//
//            self.view.frame.origin.y = 0
//
//        default:
//            break
//        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)

        return true

    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(#function)

    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print(#function)

        return true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)

        //let rowHeight = contentHeight + (hasHeader ? 50 : 20)

        
        switch textField {
        case QuestionTextField:
            //    textField.placeholder = (textField.text == nil) ? textField.placeholder : "Введите текст вопроса"
            if textField.text == "" {
                textField.placeholder = "Введите текст вопроса"
            } else {
            //    calculateKeyboardHeigh(textfield: RightAnswerTextField)
                RightAnswerTextField.becomeFirstResponder()
                
            }
        case RightAnswerTextField:
            if textField.text == "" {
                textField.placeholder = "Введите правильный ответ"
            } else {
              //  calculateKeyboardHeigh(textfield: WrongAnswer1TextField)
                WrongAnswer1TextField.becomeFirstResponder()
            }
        case WrongAnswer1TextField:
            if textField.text == "" {
                textField.placeholder = "Введите неправильный ответ №1"
            } else {
              //  calculateKeyboardHeigh(textfield: WrongAnswer2TextField)
                WrongAnswer2TextField.becomeFirstResponder()
            }
        case WrongAnswer2TextField:
            if textField.text == "" {
                textField.placeholder = "Введите неправильный ответ №2"
            } else {
              //  calculateKeyboardHeigh(textfield: WrongAnswer3TextField)
                WrongAnswer3TextField.becomeFirstResponder()
            }
        case WrongAnswer3TextField:
            if textField.text == "" {
                textField.placeholder = "Введите неправильный ответ №3"
            } else {
             //   calculateKeyboardHeigh(textfield: WrongAnswer1TextField)
              //  self.view.frame.origin.y = 0
                WrongAnswer3TextField.resignFirstResponder()
            }
        default:
            break
        }
        
        return true

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
