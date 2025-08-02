//
//  Viewable.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import Foundation
import UIKit

protocol Viewable: AnyObject {
    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func presentPartially(_ vc: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    func dismiss(animated: Bool, _completion:  @escaping (() -> Void))
    func pushToRoot(animated: Bool)
}

extension Viewable where Self: UIViewController {

    func push(_ vc: UIViewController, animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: animated)
    }

    func present(_ vc: UIViewController, animated: Bool) {
        vc.modalPresentationStyle = .overCurrentContext
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: .curveEaseOut) {
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = (self.navigationController?.view.frame.maxY ?? 0.0) + tabBarFrame.height
            }
            self.navigationController?.view.layoutIfNeeded()
        }
        self.view.alpha = 0.5
        self.present(vc, animated: animated, completion: nil)
    }
    
    func presentPartially(_ vc: UIViewController, animated: Bool) {
        self.view.alpha = 0.5
        self.present(vc, animated: animated, completion: nil)
    }

    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, _completion: @escaping (() -> Void)) {
        self.dismiss(animated: animated, completion: _completion)
    }

    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    func pushToRoot(animated: Bool) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: animated)
        }
    }
}
