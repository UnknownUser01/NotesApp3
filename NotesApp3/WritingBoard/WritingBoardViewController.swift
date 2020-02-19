//
//  WritingBoardViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 04/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit
class WritingBoardViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    var titleValue: String?
    var notesValue: String?
    var delegate: DoneWritingDelegate?
    var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(red: 43/255.0, green: 79/255.0, blue: 133/255.0, alpha: 1.0)
        navigationBar.isTranslucent = false
        // status bar text => white
        navigationBar.barStyle = .black
        // nav bar elements color => white
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(red: 43/255.0, green: 79/255.0, blue: 133/255.0, alpha: 1.0)
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
        }
        notesTextView.layer.borderWidth = 1
        showNotes(titleString: titleValue, notesString: notesValue)
    }
    
    @IBAction func cancelButton(_ sender: Any){
        titleTextField.text = ""
        notesTextView.text = ""
        delegate?.deselectTable()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        storeData()
    }
}

extension WritingBoardViewController {
    func storeData() {
        if let text = titleTextField.text, !checkWhiteSpaces(checkString: text)  {
            titleValue = text
        } else { titleValue = "" }
        
        if let text = notesTextView.text, !checkWhiteSpaces(checkString: text) {
            notesValue = text
        } else { notesValue = "" }
        checkEmptyFields()
    }
    
    func checkEmptyFields() {
        if titleValue == "", notesValue == "" {
                showAlert(title: "Alert!", message: "Enter Title or Notes")
        } else {
            checkForTitle()
            delegate?.doneWriting(title: titleValue, notes: notesValue)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkForTitle() {
        if (titleValue == "") {
            titleValue = "No Title"
        }
    }
    
    func showNotes(titleString: String?, notesString: String?) {
        if let title = titleString {
            titleTextField.text = title
        }
        if let notes = notesString {
            notesTextView.text = notes
        }
    }
    
    func checkWhiteSpaces(checkString: String) -> Bool {
        for chars in checkString {
            if chars != " " {
                return false
            }
            else {
                showAlert(title: "Alert!", message: "Invalid Entry.")
            }
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        titleTextField.text = ""
        notesTextView.text = ""
    }
}
