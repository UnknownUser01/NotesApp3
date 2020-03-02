//
//  StartQuizViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 27/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit

class StartQuizViewController: UIViewController {

    @IBOutlet weak var resultsHeadingLabel: UILabel!
    @IBOutlet weak var resultsValueLabel: UILabel!
    @IBOutlet weak var mainTabBar: UITabBar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var labelVisible = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarStyle()
        setNavigationBarStyle()
        setDefaultTabBar()
        setLabelVisibility()
    }
    @IBAction func takeQuizButton(_ sender: Any) {
        let viewController = UIViewController.conductQuizView
        self.present(viewController, animated: true, completion: nil)
    }
}

extension StartQuizViewController {
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
    
    func setDefaultTabBar() {
        mainTabBar.delegate = self
        mainTabBar.selectedItem = mainTabBar.items?.last
    }
    
    func setLabelVisibility() {
        resultsHeadingLabel.isHidden = labelVisible
        resultsValueLabel.isHidden = labelVisible
    }
}

extension StartQuizViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if mainTabBar.selectedItem?.title == "Notes" {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
