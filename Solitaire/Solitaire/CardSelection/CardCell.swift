//
//  CardCell.swift
//  Solitaire
//
//  Created by Smit Gandhi on 11/07/25.
//

import UIKit

class CardCell: UICollectionViewCell {

    static let identifier = "CardCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UIButton!
    
    let overlayView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        print("CardCell loaded from nib")
        setupViews()
    }
    
    private func setupViews() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        containerView.backgroundColor = .blue
        
        contentView.backgroundColor = .clear

        cardImageView.contentMode = .scaleAspectFit
        cardImageView.translatesAutoresizingMaskIntoConstraints = false

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.layer.cornerRadius = 12
        overlayView.isHidden = true

//        pointsLabel.font = .boldSystemFont(ofSize: 14)
//        pointsLabel.textAlignment = .center
//        pointsLabel.textColor = .white
//        pointsLabel.backgroundColor = .systemOrange
//        pointsLabel.layer.cornerRadius = 18
//        pointsLabel.clipsToBounds = true
//        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
//        pointsLabel.isHidden = true
        pointsLabel.appPrimaryButton(isEnable: true, title: "", titleFont: AppConstants.Fonts.MarkerFeltThin_16!)

        contentView.addSubview(cardImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(pointsLabel)

//        NSLayoutConstraint.activate([
//            cardImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            cardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            cardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            pointsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            pointsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            pointsLabel.heightAnchor.constraint(equalToConstant: 36),
//            pointsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
//        ])
    }

    func configure(with item: CardItem) {
        cardImageView.image = item.image

        switch item.state {
        case .purchasedSelected:
            overlayView.isHidden = true
            overlayView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.4)
            pointsLabel.isHidden = true

        case .purchasedNotSelected:
            overlayView.isHidden = true
            pointsLabel.isHidden = true

        case .notPurchased:
            overlayView.isHidden = true
            pointsLabel.isHidden = false
            pointsLabel.setTitle("\(item.pointsRequired) Points", for: .normal)
        }
    }
}
