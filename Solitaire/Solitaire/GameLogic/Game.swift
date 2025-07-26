//
//  ViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 25/06/25.
//


import UIKit


class Game {
    static let sharedInstance = Game()
    
    enum MoveType {
        case tableauToFoundation
        case tableauToTableau
        case talonToFoundation
        case talonToTableau
        case foundationToTableau
        case foundationToTalon
        case stockToTalon
    }
    
    struct Move {
        let type: MoveType
        let from: CardDataStack
        let to: CardDataStack
        let cards: [Card]
        let flippedCard: Card?  // used when a face-down card was flipped
    }

    enum RandomTask {
        case completeAllAces
        case show7OfHearts
        case fillEachFoundationOnce
        case custom(String)

        var description: String {
            switch self {
            case .completeAllAces:
                return "Complete all Aces in foundation"
            case .show7OfHearts:
                return "Make 7 of Hearts visible"
            case .fillEachFoundationOnce:
                return "Put at least one card in each foundation"
            case .custom(let str):
                return str
            }
        }
    }
    
    //Current Random Task to the player
    var currentRandomTask: RandomTask?

    private init() {
        
    }
    
    // Move history for undo
     var moveHistory: [Move] = []

    func pushMove(_ move: Move) {
        moveHistory.append(move)
    }

    func popLastMove() -> Move? {
        return moveHistory.popLast()
    }
    
    
    func moveCards(_ cards: [Card], from: CardDataStack, to: CardDataStack, type: MoveType, flippedCard: Card? = nil) {
        cards.forEach { to.addCard(card: $0) }
        for _ in cards { from.popCards(numberToPop: 1, makeNewTopCardFaceup: false) }
        moveHistory.append(Move(type: type, from: from, to: to, cards: cards, flippedCard: flippedCard))
    }
    
    func moveTopCard(from: CardDataStack, to: CardDataStack, type: MoveType? = nil, faceUp: Bool, makeNewTopCardFaceup: Bool) {
        guard let card = from.topCard() else { return }
        var flippedCard: Card? = nil
        if makeNewTopCardFaceup, let last = from.cards.dropLast().last, !last.faceUp {
            flippedCard = last
        }
        let moved = Card(value: card.value, faceUp: faceUp)
        to.addCard(card: moved)
        from.popCards(numberToPop: 1, makeNewTopCardFaceup: makeNewTopCardFaceup)
        
        if let type = type {
            moveHistory.append(Move(
                type: type,
                from: from,
                to: to,
                cards: [moved],
                flippedCard: flippedCard
            ))
        }
    }
    
    func generateSolvableDeck() -> [Int] {
        var deck: [Int] = []
        
        // 1. Add ordered suits for Foundation pre-fill (A–K of each suit)
        for suit in 0..<4 {
            for rank in 0..<13 {
                deck.append(suit * 13 + rank)
            }
        }
        
        // 2. Shuffle Tableau + Stock layout
        deck.shuffle()
        return deck
    }
    
    
    func undoLastMove() {
        guard let last = moveHistory.popLast() else { return }
        
        // Remove moved cards from 'to'
        for _ in last.cards {
            last.to.popCards(numberToPop: 1, makeNewTopCardFaceup: false)
        }
        
        // Revert flipped card if any
        if let flipped = last.flippedCard {
            var restored = flipped
            restored.faceUp = false
            last.from.cards.append(restored)
        }
        
        // Re-add original cards to 'from'
        last.cards.forEach { last.from.addCard(card: $0) }
    }
    
    func resetHistory() {
        moveHistory.removeAll()
    }
    
    func copyCards(from: CardDataStack, to: CardDataStack) {
        from.cards.forEach( { _ in self.moveTopCard(from: from, to: to, faceUp: false, makeNewTopCardFaceup: false) })
    }
    
    func shuffle() {
        Model.sharedInstance.shuffle()
    }
    
    func initalizeDeal() {
        self.shuffle()
        
        Model.sharedInstance.tableauStacks.forEach { $0.removeAllCards() }
        Model.sharedInstance.foundationStacks.forEach { $0.removeAllCards() }
        Model.sharedInstance.talonStack.removeAllCards()
        Model.sharedInstance.stockStack.removeAllCards()
    }
    
    
    func generateRandomTask() {
        let all: [RandomTask] = [.completeAllAces, .show7OfHearts, .fillEachFoundationOnce]
        currentRandomTask = all.randomElement()
    }
    
}


//MARK: Random game win logic
extension Game {

    /// Returns all top cards from foundation stacks
    func topCardsInFoundation() -> [Card] {
        return Model.sharedInstance.foundationStacks.compactMap { $0.topCard() }
    }

    ///Check all foundation cards stacks are filled or not?
    /// Checks if all suits are represented in the foundation's top cards
    func allSuitsInFoundation() -> Bool {
        let suits = topCardsInFoundation()
            .map { $0.getCardSuitAndRank().suit }
        let uniqueSuits = Set(suits)
        return uniqueSuits.count == 4
    }

    /// Checks if 7 of Hearts is visible anywhere (faceUp) on tableau
    func isSevenOfHeartsVisible() -> Bool {
        for tableau in Model.sharedInstance.tableauStacks {
            for card in tableau.cards {
                let (suit, rank) = card.getCardSuitAndRank()
                if suit == .hearts && rank == 6 && card.faceUp {
                    return true
                }
            }
        }
        return false
    }

    /// Checks if all four Aces are present in the foundation (rank == 0)
    func allAcesInFoundation() -> Bool {
        let ranks = topCardsInFoundation()
            .filter { $0.getCardSuitAndRank().rank == 0 }
        return ranks.count == 4
    }
    
}
