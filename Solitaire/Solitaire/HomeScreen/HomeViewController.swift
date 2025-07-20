//
//  HomeViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 08/07/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnPoints: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!

    private let originalCards: [CarouselCard] = [
        CarouselCard(type: .dailyChallenge, title: "Daily Challenge", subtitle: "Jul 8", buttonTitle: "Play", timer: "", imageName: "event0"),
        CarouselCard(type: .event, title: "Beat the timer", subtitle: "About to start", buttonTitle: "Play", timer: "1d 22h", imageName: "event1"),
        CarouselCard(type: .event, title: "Random Challenge", subtitle: "Event live!", buttonTitle: "Play", timer: "Now", imageName: "event2")
    ]
    private var cards: [CarouselCard] = []
    private var autoScrollTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        btnPoints.appPrimaryButton(isEnable: true, title: "Points: 1200", titleFont: AppConstants.Fonts.MarkerFeltWide_16!)
        setupCollectionView()
        setupInfiniteCarousel()
        startAutoScrollTimer()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 300, height: 366)

        // Center cards visually
        let sideInset = (view.frame.width - layout.itemSize.width) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.decelerationRate = .fast
        collectionView.register(UINib(nibName: "CarouselCardCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCardCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }

    private func setupInfiniteCarousel() {
        cards = originalCards + originalCards + originalCards
        collectionView.reloadData()

        // Scroll to center block
        DispatchQueue.main.async {
            let middleIndex = self.cards.count / 3
            let indexPath = IndexPath(item: middleIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }

    private func startAutoScrollTimer() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(autoScrollCarousel), userInfo: nil, repeats: true)
    }

    @objc private func autoScrollCarousel() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let currentOffset = collectionView.contentOffset.x
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let visibleIndex = Int(round((currentOffset + layout.sectionInset.left) / cellWidthWithSpacing))
        var nextIndex = visibleIndex + 1

        if nextIndex >= cards.count {
            nextIndex = cards.count / 3
        }

        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    private func correctScrollPositionIfNeeded() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let currentOffset = collectionView.contentOffset.x
        let cellWidthWithSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let currentIndex = Int(round((currentOffset + layout.sectionInset.left) / cellWidthWithSpacing))
        let originalCount = originalCards.count
        let middleStart = originalCount

        if currentIndex < originalCount || currentIndex >= cards.count - originalCount {
            let resetIndex = middleStart + (currentIndex % originalCount)
            let indexPath = IndexPath(item: resetIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    @objc func handlePlayButtonTapped(_ sender:UIButton) {
        startTheGame(gameType: sender.tag % originalCards.count)
    }
    
    private func startTheGame(gameType: Int){
        print("Button tap: \(gameType)")
        
        if (gameType == 0){
           //Daily Challange
            let dailyChallengeViewController = DailyChallengeViewController() // or your challenge view controller
            self.navigationController?.pushViewController(dailyChallengeViewController, animated: true)
        }else if (gameType == 1){
            //Beat the timer
            let solitaireGameViewController = SolitaireGameViewController()
            solitaireGameViewController.gameTypeStr = .TimeAttack
            self.navigationController?.pushViewController(solitaireGameViewController, animated: true)
         }else {
             //Random Challange
          }
    }
}

// MARK: - Collection View DataSource & Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = cards[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCardCell", for: indexPath) as? CarouselCardCell {
            cell.backgroundColor = .clear
            cell.cointerView.backgroundColor = .white

            cell.playButton.tag = indexPath.item
            cell.playButton.addTarget(self, action: #selector(handlePlayButtonTapped), for: .touchUpInside)

            cell.configure(with: card)

            return cell
        } else {
            print("❌ Failed to cast CarouselCardCell")
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("CollectionView Tap - IndexPath:\(indexPath)")
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // Scale down briefly, then scale back to normal
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform.identity
            }
        }
        
        let selectedCard = cards[indexPath.item % originalCards.count]
        startTheGame(gameType: indexPath.item % originalCards.count)
        print("📍 Tapped card: \(selectedCard.title)")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        correctScrollPositionIfNeeded()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        correctScrollPositionIfNeeded()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let approximatePage = (scrollView.contentOffset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing

        let page = velocity.x == 0
            ? round(approximatePage)
            : (velocity.x > 0 ? floor(approximatePage + 1) : ceil(approximatePage - 1))

        let newOffset = page * cellWidthIncludingSpacing - scrollView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: newOffset, y: scrollView.contentOffset.y)
    }

}
