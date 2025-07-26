//
//  CardSelectionCell.swift
//  Solitaire
//
//  Created by Smit Gandhi on 23/07/25.
//

import UIKit

class CardSelectionCell: UICollectionViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UIButton!
    @IBOutlet weak var flagContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.flagContainerView.layer.cornerRadius = 16
        self.flagContainerView.clipsToBounds = true
        self.flagContainerView.addViewShadow()
        
        cardImageView.contentMode = .scaleAspectFit
        cardImageView.clipsToBounds = true

        pointsLabel.appPrimaryButton(isEnable: true, title: "", titleFont: AppConstants.Fonts.MarkerFeltThin_16!)

    }

    func configure(with item: CardItem) {
        cardImageView.image = UIImage(named: item.imageString)
        pointsLabel.appPrimaryButton(isEnable: true, title: "\(item.pointsRequired) Points", titleFont: AppConstants.Fonts.MarkerFeltThin_12!)

        switch item.state {
        case .purchasedSelected:
//            overlayView.isHidden = true
//            overlayView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.4)
            pointsLabel.isHidden = false

        case .purchasedNotSelected:
//            overlayView.isHidden = true
            pointsLabel.isHidden = false

        case .notPurchased:
//            overlayView.isHidden = true
            pointsLabel.isHidden = false
        }
    }
}
