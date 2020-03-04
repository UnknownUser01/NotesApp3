//
//  LoginPageViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 22/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var containerBtmConstrain: NSLayoutConstraint!
    var activeField: UITextField?
    
    var listOfErrorLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.containerDependOnKeyboardBottomConstrain = containerBtmConstrain
        self.watchForKeyboard()
        listOfErrorLabels = [usernameErrorLabel, passwordErrorLabel]
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == passwordTextField {
            self.loginButton(true)
        }
        return false
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
        let viewController = UIViewController.mainView
        usernameTextField.text = ""
        passwordTextField.text = ""
        self.present(viewController, animated: true, completion: nil)
    }
}

//extension LoginPageViewController {
//
//    func animateWithKeyboard(notification: NSNotification) {
//
//        // Based on both Apple's docs and personal experience,
//        // I assume userInfo and its documented keys are available.
//        // If you'd like, you can remove the forced unwrapping and add your own default values.
//        if let userInfo = notification.userInfo {
//            let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0.0
//            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
//            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
//            let moveUp = (notification.name == UIResponder.keyboardWillShowNotification)
//
//            // baseContraint is your Auto Layout constraint that pins the
//            // text view to the bottom of the superview.
//
//            self.bottomContraint?.constant = moveUp ? -keyboardHeight : 0
//
//            let options = UIView.AnimationOptions(rawValue: curve << 16)
//            UIView.animate(withDuration: duration, delay: 0, options: options,
//                           animations: {
//                            self.view.layoutIfNeeded()
//            },
//                           completion: nil
//            )
//        }
//
//    }
//
//    func keyboardNotification(notification: NSNotification) {
//
//        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
//
//        if let userInfo = notification.userInfo {
//            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            let endFrameHeight = endFrame?.size.height ?? 0.0
//            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseIn.rawValue
//            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
//            self.view.
//            self.bottomSpacingConstraint.constant = isShowing ? endFrameHeight : 0.0
//            UIView.animate(withDuration: duration,
//                                       delay: TimeInterval(0),
//                options: animationCurve,
//                animations: { self.view.layoutIfNeeded() },
//                completion: nil)
//        }
//    }
