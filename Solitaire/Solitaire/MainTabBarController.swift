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
    private lazy var homeVC: UINavigationController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        return UINavigationController(rootViewController: vc)
    }()
    
    private let settingsVC = SettingsViewController()
    
    private var tabButtons: [UIButton] = []
    private var currentTabIndex: Int = 1
    
    private var currentVC: UIViewController?
    
    let tabOrder = [
        ["Title": "Daily Challenge","ID":0,"imageNames":"house","selectedImageNames":"house.fill"],
        ["Title":"New Deal", "ID": 1,"imageNames":"play.circle","selectedImageNames":"play.circle.fill"],
        ["Title":"Settings", "ID":2,"imageNames":"gearshape","selectedImageNames":"gearshape.fill"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTabBar()
        updateSelectedTab(index: 0)
        switchToVC(homeVC)
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
       let selectors: [Selector] = [#selector(openChallenge), #selector(openPlay), #selector(openSettings)]
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, tabValue) in tabOrder.enumerated() {
            let button = UIButton(type: .system)
            button.tag = tabValue["ID"] as! Int
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            button.titleLabel?.textAlignment = .center

            var config = UIButton.Configuration.filled()
            config.background.backgroundColor = .clear
            config.title = tabValue["Title"] as? String
            config.image = UIImage(systemName: tabValue["imageNames"] as! String)
            config.imagePlacement = .top
            config.imagePadding = 6
            config.baseForegroundColor = .white

            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var updated = incoming
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                updated.foregroundColor = .white
                updated.font = UIFont.systemFont(ofSize: 10)
                return updated
            }

            button.configuration = config
            button.addTarget(self, action: selectors[index], for: .touchUpInside)

            tabButtons.append(button)
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
    
    @objc private func openChallenge() {
        updateSelectedTab(index: 0)
        switchToVC(homeVC)
    }
    @objc private func openPlay() {
        updateSelectedTab(index: 1)
        switchToVC(playVC)
    }
    @objc private func openSettings() {
        updateSelectedTab(index: 2)
        switchToVC(settingsVC)
    }
    
    private func updateSelectedTab(index: Int) {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        
        for (i, button) in tabButtons.enumerated() {
            let tabValue = self.tabOrder[i]
            let imageName = (i == index) ? tabValue["selectedImageNames"] as! String : tabValue["imageNames"] as! String
            let image = UIImage(systemName: imageName, withConfiguration: config)
            
            var config = button.configuration
            config?.image = image
            button.configuration = config
        }
        
        currentTabIndex = index
    }
}
