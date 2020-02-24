//
//  LoginPageViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 22/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    var listOfErrorLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listOfErrorLabels = [usernameErrorLabel, passwordErrorLabel]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        validateField(textField: usernameTextField, errorLabel: usernameErrorLabel, rightString: Strings.admin, errorMessage: Strings.invalidUsername)
        validateField(textField: passwordTextField, errorLabel: passwordErrorLabel, rightString: Strings.root123, errorMessage: Strings.invalidPassword)
        if canProceed() == true {
            goToNextView()
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        usernameTextField.text = ""
        passwordTextField.text = ""
        removeError(textField: usernameTextField, errorLabel: usernameErrorLabel)
        removeError(textField: passwordTextField, errorLabel: passwordErrorLabel)
    }
}

extension LoginPageViewController {
    
    func validateField(textField: UITextField, errorLabel: UILabel, rightString: String, errorMessage: String) {
        if let fieldData = textField.text {
            if fieldData != rightString {
                showError(textField: textField, errorLabel: errorLabel, errorMessage: errorMessage)
                return
            }
        }
        removeError(textField: textField, errorLabel: errorLabel)
    }
    
    func showError(textField: UITextField, errorLabel: UILabel, errorMessage: String) {
        let myColor: UIColor = .red
        textField.layer.masksToBounds = true
        textField.layer.borderColor = myColor.cgColor
        textField.layer.borderWidth = 1.5
        errorLabel.isHidden = false
        errorLabel.text = errorMessage
        errorLabel.font = errorLabel.font.withSize(10)
        errorLabel.textColor = .red
    }
    
    func removeError(textField: UITextField, errorLabel: UILabel) {
        let myColor: UIColor = .clear
        textField.layer.masksToBounds = false
        textField.layer.borderColor = myColor.cgColor
        textField.layer.borderWidth = 0
        textField.backgroundColor = UIColor .white
        errorLabel.isHidden = true
    }
    
    func canProceed() -> Bool {
        for label in listOfErrorLabels where label.isHidden == false {
            return false
        }
        return true
    }
    
    func goToNextView() {
        let storyboard = UIStoryboard(name: Strings.main, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        if let newViewController = viewController as? MainViewController {
            newViewController.modalPresentationStyle = .fullScreen
            usernameTextField.text = ""
            passwordTextField.text = ""
            self.present(newViewController, animated: true, completion: nil)
        }
    }
}
