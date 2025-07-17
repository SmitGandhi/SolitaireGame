//
//  ViewController+Extensions.swift
//  CSC
//
//  Created by Adavan on 21/05/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController : UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        ConsoleLog.shared.log("Tab select")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension UIViewController {
    
    func showCommonAlert(title:String, message:String, ok:String, cancel:String, okClicked: @escaping ()->(), cancelAction:@escaping ()->()){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            ConsoleLog.shared.log("OK")
            okClicked()
        }
        
        let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.default){ (result : UIAlertAction) -> Void in
            ConsoleLog.shared.log("OK")
            cancelAction()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func  showMessageAlert(title:String, message:String, ok:String, complition: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message:message , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title:ok, style: .cancel, handler:  { (action) in
            complition()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func  showMessageActionSheet(title:String, message:String, ok:String, complition: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title:message, style: .default, handler:  { (action) in
            
            complition()
        }))
        
        alert.addAction(UIAlertAction(title:ok, style: .cancel, handler:  { (action) in
            
            // complition()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicatory() {
        let screenSize:CGRect = UIScreen.main.bounds
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        bgView.tag = 1201
        bgView.backgroundColor = UIColor.clear
        let bgBounds = bgView.bounds
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: Int(bgBounds.width / 2) - 18,
                                                                      y: Int(bgBounds.height / 2) - 18, width: 37, height: 37))
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.color = UIColor(red: 0.698, green: 0.161, blue: 0.176, alpha: 1)
        bgView.addSubview(activityIndicator)
        self.view.addSubview(bgView)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func  hideActivityIndicator() {
        if let bgView = self.view.viewWithTag(1201) {
            bgView.removeFromSuperview()
        }
    }
    
    func runOnUIThread(execute work: @escaping @convention(block) () -> Void) {
        DispatchQueue.main.async {
            work()
        }
    }
}

//MARK:- get view controller for nav controller
extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }

}
