//
//  ConductQuizViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 27/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit

struct questionsAndOptions {
    var question: String
    var option1: String
    var option2: String
    var option3: String
    var option4: String
    var rightAnswer: String
}

class ConductQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var quizTable: UITableView!
    var listOfQuestionNumbers = [Int]()
    let questionObject = Questions()
    
    var arrayOfQuestions = [questionsAndOptions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseQuestions()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let cell = Bundle.main.loadNibNamed(Strings.quizQuestionCell, owner: self, options: nil)?.first as? QuizQuestionCell {
            addQuestionToCell(cell: cell, index: indexPath.row)
            return cell
        }
        return cell
    }
        
        @IBAction func exitButton(_ sender: Any) {
            showAlert(title: Strings.alert, message: Strings.areYouSureToQuit)
        }
        
        @IBAction func submitButton(_ sender: Any) {
            showAlert(title: Strings.alert, message: Strings.areYouSure)
        }
}

extension ConductQuizViewController {
    func setDefaultTableSettings() {
        quizTable.separatorStyle = .none
        quizTable.delegate = self
        quizTable.dataSource = self
        quizTable.tableFooterView = UIView()
        quizTable.tableFooterView = UIView()
    }
}

extension ConductQuizViewController {
    func addQuestionToCell(cell: QuizQuestionCell, index: Int) {
        cell.questionNumberLabel.text = String(index + 1)
        cell.questionLabel.text = arrayOfQuestions[index].question
        cell.option1Button.setTitle(arrayOfQuestions[index].option1, for: .normal)
        cell.option2Button.setTitle(arrayOfQuestions[index].option2, for: .normal)
        cell.option3Button.setTitle(arrayOfQuestions[index].option3, for: .normal)
        cell.option4Button.setTitle(arrayOfQuestions[index].option4, for: .normal)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.yesIAmSure, style: .default, handler: { _ in self.dismiss(animated: false, completion: nil) }))
        alert.addAction(UIAlertAction(title: Strings.noIwillContinue, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func extractQuestions(questionNumber: String) {
        let question = "Question " + questionNumber
        for _ in 0...30 {
            if question == questionObject.siNum{
                
            }
        }
    }
    
    func chooseQuestions() {
        var questionNumber = 0
        for _ in 1...10 {
            questionNumber = getRandomNumber()
            listOfQuestionNumbers.append(questionNumber)
            extractQuestions(questionNumber: String(questionNumber))
        }
    }
    
    func getRandomNumber() -> Int {
        var randomNumber = 0
        var numberPresentFlag = false
        while true {
            numberPresentFlag = false
            randomNumber = Int.random(in: 1...30)
            for number in listOfQuestionNumbers where number == randomNumber {
                numberPresentFlag = true
            }
            if !numberPresentFlag {
                break
            }
        }
        return randomNumber
    }
}
