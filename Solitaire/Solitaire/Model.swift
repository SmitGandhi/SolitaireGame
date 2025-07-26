//
//  ViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 25/06/25.
//

import UIKit

class Model {
    static let sharedInstance = Model()

    var deck = Array(0 ..< 52)
    var cards = [CardView]()  // persistent storage of cardViews

    var tableauStacks = [TableauStack]()
    var foundationStacks = [FoundationStack]()
    var talonStack = TalonStack()
    var stockStack = StockStack()
    var dragStack = DragStack()
    
    private init() {
        self.initialize()
    }
    
    func shuffle() {
        self.deck.shuffle()
    }
    
    private func initialize() {
        // frame is just a default placeholder. real frame is set in stack views
        // but need width and height to initalize subviews in cardview
        let frame = CGRect(x: 0, y: 0, width: CARD_WIDTH, height: CARD_HEIGHT)
        for index in deck {
            self.cards.append(CardView(frame: frame, value: self.deck[index]))
        }
        
        for _ in 0 ..< 4 {
            self.foundationStacks.append(FoundationStack())
        }
        
        for _ in 0 ..< 7 {
            self.tableauStacks.append(TableauStack())
        }
    }
    
    func resetGameState() {
        // Clear old data
        self.cards.removeAll()
        self.tableauStacks.removeAll()
        self.foundationStacks.removeAll()
//        self.talonStack = TalonStack()
//        self.stockStack = StockStack()
//        self.dragStack = DragStack()
//        
//        // Reshuffle or keep existing deck
        self.deck = Array(0 ..< 52)
//        self.shuffle()
//
        // Recreate card views with new background
        let frame = CGRect(x: 0, y: 0, width: CARD_WIDTH, height: CARD_HEIGHT)
        for index in deck {
            self.cards.append(CardView(frame: frame, value: self.deck[index]))
        }

        // Recreate foundation/tableau stacks
        for _ in 0 ..< 4 {
            self.foundationStacks.append(FoundationStack())
        }

        for _ in 0 ..< 7 {
            self.tableauStacks.append(TableauStack())
        }
    }
}
