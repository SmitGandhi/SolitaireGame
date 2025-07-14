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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.loadNewGame()
    }
    
    @objc func loadNewGame() {
        // Remove old view if any
        gameView?.removeFromSuperview()
        
        let solitaireView = SolitaireGameView(frame: self.view.bounds)
        solitaireView.delegate = self
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

