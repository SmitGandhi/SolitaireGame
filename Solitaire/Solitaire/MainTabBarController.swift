//
//  MainTabBarController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 03/07/25.
//


import UIKit
import Foundation

class MainTabBarController: UIViewController {
    
    private let customTabBar = CustomTabBarView()
    private let playVC = SolitaireGameViewController()
    private let challengeVC = DailyChallengeViewController()
    private let settingsVC = SettingsViewController()

    private var currentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupTabBar()
        switchToVC(playVC)
    }

    private func setupTabBar() {
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)

        NSLayoutConstraint.activate([
            customTabBar.heightAnchor.constraint(equalToConstant: 70),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])

        // Add buttons/icons
        let buttonTitles = ["Daily Challenge", "New Deal", "Settings"]
        let imageNames = ["calendar", "play.circle.fill", "gearshape"] // SF Symbols or use custom assets

        let selectors: [Selector] = [#selector(openChallenge), #selector(openPlay), #selector(openSettings)]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            // Configure image
                let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
                let image = UIImage(systemName: imageNames[index], withConfiguration: config)
                button.setImage(image, for: .normal)
                button.tintColor = .white

                // Configure title
                button.setTitle(title, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 10)

                // Layout image on top, text on bottom
                button.contentHorizontalAlignment = .center
                button.contentVerticalAlignment = .center
                button.titleEdgeInsets = UIEdgeInsets(top: 35, left: -36, bottom: 0, right: 0)
                button.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: -button.titleLabel!.intrinsicContentSize.width)
            
            // Action
                button.addTarget(self, action: selectors[index], for: .touchUpInside)
            
            stack.addArrangedSubview(button)
        }

        customTabBar.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: customTabBar.topAnchor),
            stack.bottomAnchor.constraint(equalTo: customTabBar.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor, constant: -20)
        ])
    }

    private func switchToVC(_ vc: UIViewController) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        addChild(vc)
        view.insertSubview(vc.view, belowSubview: customTabBar)
        vc.view.frame = view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: self)
        currentVC = vc
    }

    @objc private func openChallenge() { switchToVC(challengeVC) }
    @objc private func openPlay() { switchToVC(playVC) }
    @objc private func openSettings() { switchToVC(settingsVC) }
}
