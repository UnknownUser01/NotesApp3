//
//  ConductQuizViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 27/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit

class ConductQuizViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var quizTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultTableSettings()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        return cell
    }

    @IBAction func exitButton(_ sender: Any) {
    }
    
    @IBAction func submitButton(_ sender: Any) {
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
