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
            fatalError("WritIngBoard view contorller cannot be nil")
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
    
}
