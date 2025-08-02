//
//  ShimmerCellTableViewCell.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import UIKit

class ShimmerCellTableViewCell: UITableViewCell {
    
    let shimmerView = UIView()
    let gradientLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupShimmer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmer()
    }
    
    private func setupShimmer() {
        self.selectionStyle = .none
        shimmerView.backgroundColor = .systemGray5
        shimmerView.layer.cornerRadius = 8
        shimmerView.clipsToBounds = true
        contentView.addSubview(shimmerView)

        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shimmerView.heightAnchor.constraint(equalToConstant: 134), // Explicit height
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        gradientLayer.colors = [
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 0.5, 1]
        shimmerView.layer.addSublayer(gradientLayer)

        startShimmer()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = shimmerView.bounds
    }
    
    func startShimmer() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerEffect")
    }
    
    func stopShimmer() {
        gradientLayer.removeAllAnimations()
    }
    
}
