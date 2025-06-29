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
    
}
