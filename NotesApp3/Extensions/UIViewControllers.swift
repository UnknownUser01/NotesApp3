//
//  UIViewControllers.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 25/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import Foundation

extension UIViewController {
    
    static var mainView: MainViewController {
        guard let mainView = UIStoryboard.main.instantiateInitialViewController() as? MainViewController else {
            fatalError("Main view contorller cannot be nil")
        }
        mainView.modalPresentationStyle = .fullScreen
        return mainView
    }
    
    static var writeView: WritingBoardViewController {
        guard let writeView = UIStoryboard.write.instantiateInitialViewController() as? WritingBoardViewController else {
            fatalError("WritingBoard view contorller cannot be nil")
        }
        writeView.modalPresentationStyle = .fullScreen
        return writeView
    }
    
    static var loginView: LoginPageViewController {
        guard let mainView = UIStoryboard.main.instantiateInitialViewController() as? LoginPageViewController else {
            fatalError("Login view contorller cannot be nil")
        }
        return mainView
    }
    
    static var startQuizView: StartQuizViewController {
        guard let startQuizView = UIStoryboard.startQuiz.instantiateInitialViewController() as? StartQuizViewController else {
            fatalError("StartQuiz view controller cannot be nil")
        }
        startQuizView.modalPresentationStyle = .fullScreen
        return startQuizView
    }
    
    static var conductQuizView: ConductQuizViewController {
        guard let conductQuizView = UIStoryboard.conductQuiz.instantiateInitialViewController() as? ConductQuizViewController else {
            fatalError("ConductQuiz view controller cannot be nil")
        }
        conductQuizView.modalPresentationStyle = .fullScreen
        return conductQuizView
    }
    
}

private var xoAssociationKeyForBottomConstrainInVC: UInt8 = 0

extension UIViewController {
    
    var containerDependOnKeyboardBottomConstrain: NSLayoutConstraint! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKeyForBottomConstrainInVC) as? NSLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKeyForBottomConstrainInVC, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func watchForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWasShown(notification: NSNotification) {
        var keyboardFrames: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        if let info = notification.userInfo {
            guard let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            keyboardFrames = keyboardFrame
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.containerDependOnKeyboardBottomConstrain.constant = keyboardFrames.height
            self.view.layoutIfNeeded()
        })
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.containerDependOnKeyboardBottomConstrain.constant = 0
            self.view.layoutIfNeeded()
        })
    }
}
