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
    weak var delegate: WritingBoardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarStyle()
        setNavigationBarStyle()
        notesTextView.layer.borderWidth = 1
        showNotes(titleString: titleValue, notesString: notesValue)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        titleTextField.text = ""
        notesTextView.text = ""
        delegate?.diddDeselectTable()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        storeData()
    }
}

extension WritingBoardViewController {
    func storeData() {
        if let text = titleTextField.text, !checkWhiteSpaces(checkString: text) {
            titleValue = text
        } else { titleValue = "" }
        if let text = notesTextView.text, !checkWhiteSpaces(checkString: text) {
            notesValue = text
        } else { notesValue = "" }
        checkEmptyFields()
    }
    
    func checkEmptyFields() {
        if titleValue == "", notesValue == "" {
            showAlert(title: Strings.alert, message: Strings.enterTitleOrNotes)
        } else {
            checkForTitle()
            delegate?.didWriteNote(title: titleValue, notes: notesValue)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkForTitle() {
        if titleValue == "" {
            titleValue = Strings.noTitle
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
            } else { showAlert(title: Strings.alert, message: Strings.invalidEntry) }
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.okay, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        titleTextField.text = ""
        notesTextView.text = ""
    }
    
    func setStatusBarStyle() {
        if #available(iOS 13.0, *) {
            let windowKey = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first(where: { $0.isKeyWindow })
            if let frame = windowKey?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBar = UIView(frame: frame)
                statusBar.backgroundColor = UIColor.darkBlue
                view.addSubview(statusBar)
            }
        }
    }
    
    func setNavigationBarStyle() {
        navigationBar.barTintColor = UIColor.darkBlue
        navigationBar.isTranslucent = false
        // status bar text => white
        navigationBar.barStyle = .black
        // nav bar elements color => white
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

protocol WritingBoardViewControllerDelegate: class {
    func didWriteNote(title: String?, notes: String?)
    func diddDeselectTable()
}
