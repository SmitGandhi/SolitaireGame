//
//  CardSelectionViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 10/07/25.
//

import UIKit

enum CardState {
    case purchasedSelected
    case purchasedNotSelected
    case notPurchased
}

struct CardItem {
    let image: UIImage
    let pointsRequired: Int
    var isPurchased: Bool
    var isSelected: Bool

    var state: CardState {
        if isPurchased {
            return isSelected ? .purchasedSelected : .purchasedNotSelected
        } else {
            return .notPurchased
        }
    }
}


class CardSelectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cardItems: [CardItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadCards()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
        
    }
    
    
    func loadCards() {
        cardItems = [
            CardItem(image: UIImage(named: "PlayingCard-back")!, pointsRequired: 50, isPurchased: true, isSelected: true),
            CardItem(image: UIImage(named: "PlayingCard-back_1")!, pointsRequired: 75, isPurchased: true, isSelected: false),
            CardItem(image: UIImage(named: "PlayingCard-back_2")!, pointsRequired: 100, isPurchased: false, isSelected: false),
            CardItem(image: UIImage(named: "PlayingCard-back_3")!, pointsRequired: 100, isPurchased: false, isSelected: false),
            // Add more...
        ]
        collectionView.reloadData()
    }
}

extension CardSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as! CardCell
        cell.configure(with: cardItems[indexPath.item])
        cell.backgroundColor = .yellow
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCard = cardItems[indexPath.item]

        switch selectedCard.state {
        case .purchasedSelected:
            break // Already selected

        case .purchasedNotSelected:
            // Deselect others, select this
            for i in 0..<cardItems.count {
                cardItems[i].isSelected = false
            }
            cardItems[indexPath.item].isSelected = true

        case .notPurchased:
            let userPoints = 1250 // Replace with your user's current points
            if userPoints >= selectedCard.pointsRequired {
                cardItems[indexPath.item].isPurchased = true
                cardItems[indexPath.item].isSelected = true
                // Deduct points & refresh UI
            } else {
                print("Not enough points")
            }
        }

        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 12
        let sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        let totalSpacing = sectionInsets.left + sectionInsets.right + (spacing * (itemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = floor(availableWidth / itemsPerRow)

        // Maintain card aspect ratio (253 x 379)
        let itemHeight = itemWidth * (379.0 / 253.0)

        return CGSize(width: itemWidth-10, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}

