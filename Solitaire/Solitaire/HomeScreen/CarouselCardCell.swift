//
//  CarouselCardCell.swift
//  Solitaire
//
//  Created by Smit Gandhi on 08/07/25.
//


import UIKit

class CarouselCardCell: UICollectionViewCell {

    @IBOutlet weak var cointerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        print("✅ CarouselCardCell loaded from nib")
        setupCard()

    }
    
    private func setupCard() {
        self.backgroundColor = .white
        
        cointerView.backgroundColor = .white
        cointerView.layer.cornerRadius = 12
        cointerView.layer.shadowColor = UIColor(red: 3/255, green: 3/255, blue: 3/255, alpha: 0.1).cgColor

        cointerView.layer.shadowOpacity = 1
        cointerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cointerView.layer.shadowRadius = 4.5

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AppConstants.Fonts.MarkerFeltThin_16!
    }

    func configure(with card: CarouselCard) {
        titleLabel.text = card.title
        playButton.appPrimaryButton(isEnable: true, title: card.buttonTitle ?? "Play", titleFont: AppConstants.Fonts.MarkerFeltWide_14!)
        imageView.image = UIImage(named: card.imageName)
    }
}
