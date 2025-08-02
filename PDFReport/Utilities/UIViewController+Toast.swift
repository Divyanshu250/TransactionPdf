//
//  Utility.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            let toastLabel = UILabel()
            toastLabel.text = message
            toastLabel.font = .systemFont(ofSize: 14)
            toastLabel.textColor = .white
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            toastLabel.textAlignment = .center
            toastLabel.alpha = 0.0
            toastLabel.numberOfLines = 0
            
            let padding: CGFloat = 16
            let maxLabelWidth = self.view.frame.width - 2 * padding
            let expectedSize = toastLabel.sizeThatFits(CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude))
            let labelWidth = min(maxLabelWidth, expectedSize.width + padding)
            let labelHeight = expectedSize.height + 20
            
            toastLabel.frame = CGRect(
                x: (self.view.frame.width - labelWidth) / 2,
                y: self.view.frame.height - 100,
                width: labelWidth,
                height: labelHeight
            )
            
            toastLabel.layer.cornerRadius = 10
            toastLabel.clipsToBounds = true
            
            self.view.addSubview(toastLabel)
            
            UIView.animate(withDuration: 0.3, animations: {
                toastLabel.alpha = 1.0
            }) { _ in
                UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                    toastLabel.alpha = 0.0
                }) { _ in
                    toastLabel.removeFromSuperview()
                }
            }
        }
    }
}
