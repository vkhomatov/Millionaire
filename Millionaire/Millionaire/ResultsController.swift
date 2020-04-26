//
//  ResultsController.swift
//  Millionaire
//
//  Created by Vitaly Khomatov on 21.04.2020.
//  Copyright © 2020 Macrohard. All rights reserved.
//

import UIKit

class ResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var ResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResultsTableView.dataSource = self
        ResultsTableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count =  Game.shared.results?.count else  {
            return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ResultsTableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultCell
        
        if Game.shared.results == nil  { return cell }
        
        cell.DateLabel.text = Game.shared.results![indexPath.row].dateGame
        cell.PrizeLabel.text = String(Game.shared.results![indexPath.row].prizeCount)
        cell.RightAnswersCountLabel.text = String(Game.shared.results![indexPath.row].rightAnswerCount) + "/" + String(Game.shared.questions!.count)
        cell.ShuffleAnswersLabel.text = Game.shared.results![indexPath.row].randomQuestionsString
        cell.PromptsUseCountLabel.text = String(Game.shared.results![indexPath.row].promtUseCount)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if Game.shared.results != nil
            {
                Game.shared.results!.remove(at: indexPath.row)
                ResultsTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    
}
