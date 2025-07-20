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
    var gameTypeStr: gameType = .TimeAttack
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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController as? MainTabBarController {
            root.hideCustomTabBar()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController as? MainTabBarController {
            root.showCustomTabBar()
        }
    }
    
    @objc func loadNewGame() {
        // Remove old view if any
        gameView?.removeFromSuperview()
        
        let solitaireView = SolitaireGameView(frame: self.view.bounds)
        solitaireView.delegate = self
        solitaireView.gameDate = gameDate
        solitaireView.gameTypeStr = gameTypeStr
        if gameTypeStr == .TimeAttack {
            solitaireView.secondsElapsed = AppConstants.AppConfigurations.timerGameCount
        }
        
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

