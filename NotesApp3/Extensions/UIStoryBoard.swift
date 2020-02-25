//
//  UIStoryBoard.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 25/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import Foundation
extension UIStoryboard {
    
    static let mainView = "MainViewController"
    static let loginView = "LoginViewController"
    static let writingBoardView = "WritingBoardViewController"
    
    static var main: UIStoryboard {
        return UIStoryboard(name: mainView, bundle: nil)
    }
    
    static var login: UIStoryboard {
        return UIStoryboard(name: loginView, bundle: nil)
    }
    
    static var write: UIStoryboard {
        return UIStoryboard(name: writingBoardView, bundle: nil)
    }
}
