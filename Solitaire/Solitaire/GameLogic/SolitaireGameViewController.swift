//
//  ViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 25/06/25.
//

import UIKit

class SolitaireGameViewController: UIViewController, SolitaireGameViewDelegate {
    func backToHome() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private var gameView: SolitaireGameView?
    var gameDate: String = ""

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.loadNewGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let mainTab = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController {
            mainTab.hideCustomTabBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController {
            tabBarController.showCustomTabBar()
        }
    }
    
    @objc func loadNewGame() {
        // Remove old view if any
        gameView?.removeFromSuperview()
        
        let solitaireView = SolitaireGameView(frame: self.view.bounds)
        solitaireView.delegate = self
        solitaireView.gameDate = gameDate
        self.view.addSubview(solitaireView)
        gameView = solitaireView
    }
    
    func restartGame() {
        loadNewGame()
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

