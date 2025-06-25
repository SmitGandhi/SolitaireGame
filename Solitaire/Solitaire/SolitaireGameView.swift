//
//  ViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 25/06/25.
//

import UIKit
import AVFoundation

fileprivate let SPACING = CGFloat(UIScreen.main.bounds.width > 750 ? 10.0 : 3.0)
let CARD_WIDTH = CGFloat((UIScreen.main.bounds.width - CGFloat(7.0 * SPACING)) / 7.0)
let CARD_HEIGHT = CARD_WIDTH * 1.42

private extension Selector {
    static let newDealTap = #selector(SolitaireGameView.newDealAction)
    static let hintTap = #selector(SolitaireGameView.hintAction)
    static let undoTap = #selector(SolitaireGameView.undoAction)
}

protocol SolitaireGameViewDelegate: AnyObject {
    func restartGame()
}

final class SolitaireGameView: UIView {
    enum soundType : String{
        case noHintToast    = "toast"
        case gameWin        = "gamewin"
        case cardslide      = "CardSlide"
    }
    weak var delegate: SolitaireGameViewDelegate?
    private var testModeEnabled = true
    private var isAutoPlaying = false

    private var foundationStacks = [FoundationCardStackView]()
    private var tableauStackViews = [TableauStackView]()
    private var stockStackView = StockCardStackView(frame: CGRect.zero)
    private var talonStackView = TalonCardStackView()
    private var doingDrag = false           // flag to keep callbacks from trying to do stuff on touches when not dragging
    private var dragView = DragStackView(frame: CGRect.zero, cards: Model.sharedInstance.dragStack)   // view containing cards being dragged.
    private var stackDraggedFrom: CardStackView?
    private var dragPosition = CGPoint.zero
    private var baseTableauFrameRect = CGRect.init()
    private var toastSoundPlayer: AVAudioPlayer?
    
    // Timer, moves, score
    private var timerLabel: UILabel!
    private var movesLabel: UILabel!
    private var scoreLabel: UILabel!

    private var timer: Timer?
    private var secondsElapsed = 0
    private var moveCount = 0
    private var score = 0

    private var timerStarted = false
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(hex: 0x004D2C)
        
        self.initStackViews()
        
        self.dealCards()
    }
    
//    private func initStackViews() {
//        let baseRect = CGRect(x: 4.0, y: scaled(value: 110.0), width: CARD_WIDTH, height: CARD_HEIGHT)
//        var foundationRect = baseRect
//        for index in 0 ..< 4 {
//            let stackView = FoundationCardStackView(frame: foundationRect, cards: Model.sharedInstance.foundationStacks[index])
//            self.addSubview(stackView)
//            self.foundationStacks.append(stackView)
//            foundationRect = foundationRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
//        }
//        
//        foundationRect = foundationRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
//        self.talonStackView = TalonCardStackView(frame: foundationRect, cards: Model.sharedInstance.talonStack)
//        self.addSubview(self.talonStackView)
//        
//        foundationRect = foundationRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
//        self.stockStackView = StockCardStackView(frame: foundationRect, cards: Model.sharedInstance.stockStack)
//        self.stockStackView.delegate = self
//        self.addSubview(self.stockStackView)
//        
//        var gameStackRect = baseRect.offsetBy(dx: 0.0, dy: CGFloat(CARD_HEIGHT + scaled(value: 12.0)))
//        self.baseTableauFrameRect = gameStackRect
//        for index in 0 ..< 7 {
//            let stackView = TableauStackView(frame: gameStackRect, cards: Model.sharedInstance.tableauStacks[index])
//            self.addSubview(stackView)
//            self.tableauStackViews.append(stackView)
//            gameStackRect = gameStackRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
//        }
//        
//        let screenWidth = UIScreen.main.bounds.width
//        
//        let buttonFrame = CGRect(x: 1.0, y: scaled(value: 60.0), width: scaled(value: 70.0), height: scaled(value: 30.0))
//        let newDealButton = UIButton(frame: buttonFrame)
//        newDealButton.setTitle("New Deal", for: .normal)
//        newDealButton.setTitleColor(.white, for: .normal)
//        newDealButton.titleLabel?.font = .systemFont(ofSize: scaled(value: 14.0))
//        newDealButton.addTarget(self, action: .newDealTap, for: .touchUpInside)
//        self.addSubview(newDealButton)
//        
//        let hintButtonFrame = CGRect(x: ((screenWidth/2)-35.0), y: scaled(value: 60.0), width: scaled(value: 70.0), height: scaled(value: 30.0))
//        let hintButton = UIButton(frame: hintButtonFrame)
//        hintButton.setTitle("Hint", for: .normal)
//        hintButton.setTitleColor(.white, for: .normal)
//        hintButton.titleLabel?.font = .systemFont(ofSize: scaled(value: 14.0))
//        hintButton.addTarget(self, action: .hintTap, for: .touchUpInside)
//        self.addSubview(hintButton)
//        
//        let undoButtonFrame = CGRect(x: (screenWidth-70.0), y: scaled(value: 60.0), width: scaled(value: 70.0), height: scaled(value: 30.0))
//        let undoButton = UIButton(frame: undoButtonFrame)
//        undoButton.setTitle("Undo", for: .normal)
//        undoButton.setTitleColor(.white, for: .normal)
//        undoButton.titleLabel?.font = .systemFont(ofSize: scaled(value: 14.0))
//        undoButton.addTarget(self, action: .undoTap, for: .touchUpInside)
//        self.addSubview(undoButton)
//        
//        let yOffset = scaled(value: 95.0)
//
//        timerLabel = UILabel(frame: CGRect(x: 10, y: yOffset, width: 80, height: 20))
//        movesLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width/2 - 40), y: yOffset, width: 100, height: 20))
//        scoreLabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 90, y: yOffset, width: 80, height: 20))
//
//        for label in [timerLabel, movesLabel, scoreLabel] {
//            label?.font = .systemFont(ofSize: 14.0)
//            label?.textColor = .white
//            label?.textAlignment = .center
//            self.addSubview(label!)
//        }
//
//        updateStatsLabels()
//        
//    }
    
    private func initStackViews() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let isLargeScreen = screenWidth > 600
        let buttonFontSize: CGFloat = isLargeScreen ? 30.0 : 14.0
        let labelFontSize: CGFloat = isLargeScreen ? 22.0 : 14.0
        let buttonWidth: CGFloat = isLargeScreen ? 150 : 70
        let buttonHeight: CGFloat = isLargeScreen ? 44 : 30
        let buttonY: CGFloat = isLargeScreen ? scaled(value: 40.0) : scaled(value: 60.0)

        let baseRect = CGRect(x: 4.0, y: scaled(value: 110.0), width: CARD_WIDTH, height: CARD_HEIGHT)
        var foundationRect = baseRect
        for index in 0 ..< 4 {
            let stackView = FoundationCardStackView(frame: foundationRect, cards: Model.sharedInstance.foundationStacks[index])
            self.addSubview(stackView)
            self.foundationStacks.append(stackView)
            foundationRect = foundationRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
        }

        foundationRect = foundationRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
        self.talonStackView = TalonCardStackView(frame: foundationRect, cards: Model.sharedInstance.talonStack)
        self.addSubview(self.talonStackView)

        foundationRect = foundationRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
        self.stockStackView = StockCardStackView(frame: foundationRect, cards: Model.sharedInstance.stockStack)
        self.stockStackView.delegate = self
        self.addSubview(self.stockStackView)

        var gameStackRect = baseRect.offsetBy(dx: 0.0, dy: CGFloat(CARD_HEIGHT + scaled(value: 12.0)))
        self.baseTableauFrameRect = gameStackRect
        for index in 0 ..< 7 {
            let stackView = TableauStackView(frame: gameStackRect, cards: Model.sharedInstance.tableauStacks[index])
            self.addSubview(stackView)
            self.tableauStackViews.append(stackView)
            gameStackRect = gameStackRect.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
        }

        // Buttons
        let newDealButton = UIButton(frame: CGRect(x: 10.0, y: buttonY, width: buttonWidth, height: buttonHeight))
        newDealButton.setTitle("New Deal", for: .normal)
        newDealButton.setTitleColor(.white, for: .normal)
        newDealButton.contentHorizontalAlignment = .left
        newDealButton.titleLabel?.font = .systemFont(ofSize: buttonFontSize)
        newDealButton.addTarget(self, action: .newDealTap, for: .touchUpInside)
        self.addSubview(newDealButton)

        let hintButton = UIButton(frame: CGRect(x: (screenWidth / 2 - buttonWidth / 2), y: buttonY, width: buttonWidth, height: buttonHeight))
        hintButton.setTitle("Hint", for: .normal)
        hintButton.setTitleColor(.white, for: .normal)
        hintButton.titleLabel?.font = .systemFont(ofSize: buttonFontSize)
        hintButton.addTarget(self, action: .hintTap, for: .touchUpInside)
        self.addSubview(hintButton)

        let undoButton = UIButton(frame: CGRect(x: (screenWidth - buttonWidth - 10), y: buttonY, width: buttonWidth, height: buttonHeight))
        undoButton.setTitle("Undo", for: .normal)
        undoButton.setTitleColor(.white, for: .normal)
        undoButton.contentHorizontalAlignment = .right
        undoButton.titleLabel?.font = .systemFont(ofSize: buttonFontSize)
        undoButton.addTarget(self, action: .undoTap, for: .touchUpInside)
        self.addSubview(undoButton)

//        newDealButton.backgroundColor  = .black
//        hintButton.backgroundColor  = .black
//        undoButton.backgroundColor  = .black
        
        // Labels
        let yOffset = buttonY + buttonHeight + 5

        timerLabel = UILabel(frame: CGRect(x: 10, y: yOffset, width: 100, height: 24))
        movesLabel = UILabel(frame: CGRect(x: (screenWidth / 2 - 60), y: yOffset, width: 120, height: 24))
        scoreLabel = UILabel(frame: CGRect(x: screenWidth - 110, y: yOffset, width: 100, height: 24))

        for label in [timerLabel, movesLabel, scoreLabel] {
            label?.font = .systemFont(ofSize: labelFontSize)
            label?.textColor = .white
            label?.textAlignment = .center
            self.addSubview(label!)
        }
        timerLabel.textAlignment = .left
        scoreLabel.textAlignment = .right
        updateStatsLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateStatsLabels() {
        let mins = secondsElapsed / 60
        let secs = secondsElapsed % 60
        timerLabel.text = String(format: "⏱ %02d:%02d", mins, secs)
        movesLabel.text = "Moves: \(moveCount)"
        scoreLabel.text = "Score: \(score)"
    }
    
    private func playToastSound(_ soundType: soundType) {
        guard let soundURL = Bundle.main.url(forResource: soundType.rawValue, withExtension: "wav") else {
            print("Toast sound file not found.")
            return
        }
        
        do {
            toastSoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            toastSoundPlayer?.prepareToPlay()
            toastSoundPlayer?.play()
        } catch {
            print("Error playing toast sound: \(error.localizedDescription)")
        }
    }
    
    //MARK: Undo
    @objc func undoAction() {
        self.undoCard()
    }
    
    private func undoCard() {
        print("Undo Tapped")
        self.showWinAnimation()
    }
    
    //MARK: Hint
    @objc func hintAction() {
        self.hintCard()
    }
    
    private func hintCard() {
        var hinted = false
        
        // 1. Talon → Foundation
        if let talonCard = Model.sharedInstance.talonStack.topCard(), talonCard.faceUp {
            for foundation in foundationStacks {
                if foundation.cards.canAccept(droppedCard: talonCard),
                   let talonCardView = talonStackView.subviews.compactMap({ $0 as? CardView }).last(where: { $0.cardValue == talonCard.value }) {
                    highlightHint(cardView: talonCardView)
                    hinted = true
                }
            }
        }
        
        // 2. Tableau → Foundation
        for tableau in tableauStackViews {
            if let card = tableau.cards.topCard(), card.faceUp {
                for foundation in foundationStacks {
                    if foundation.cards.canAccept(droppedCard: card),
                       let cardView = tableau.subviews.compactMap({ $0 as? CardView }).last(where: { $0.cardValue == card.value }) {
                        highlightHint(cardView: cardView)
                        hinted = true
                    }
                }
            }
        }
        
        // 3. Tableau → Tableau (highlight full movable sequences + drop targets)
        for fromTableau in tableauStackViews {
            let faceUpCardViews = fromTableau.subviews.compactMap { $0 as? CardView }.filter { $0.isFaceUp }
            
            for (i, cardView) in faceUpCardViews.enumerated() {
                let card = Card(value: cardView.cardValue, faceUp: true)
                
                for toTableau in tableauStackViews where toTableau != fromTableau {
                    if toTableau.cards.canAccept(droppedCard: card) {
                        // Highlight drop target
                        highlightStackTarget(toTableau)
                        
                        // Highlight card sequence
                        let movableViews = faceUpCardViews[i...]
                        for (j, view) in movableViews.enumerated() {
                            highlightHint(cardView: view, delay: Double(j) * 0.05)
                        }
                        hinted = true
                    }
                }
            }
        }
        
        
        // 4. Talon → Tableau
        if let talonCard = Model.sharedInstance.talonStack.topCard(), talonCard.faceUp {
            for tableau in tableauStackViews {
                if tableau.cards.canAccept(droppedCard: talonCard),
                   let talonCardView = talonStackView.subviews.compactMap({ $0 as? CardView }).last(where: { $0.cardValue == talonCard.value }) {
                    highlightHint(cardView: talonCardView)
                    hinted = true
                    break
                }
            }
        }
        
        if !hinted{//} && ghostTasks.isEmpty {
            showToast(message: "No further moves")
        }
    }
    
    private func highlightHint(cardView: CardView, delay: Double = 0) {
        UIView.animate(withDuration: 0.25, delay: delay, options: [], animations: {
            cardView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            cardView.layer.borderWidth = 2
            cardView.layer.borderColor = UIColor.yellow.cgColor
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.5, options: [], animations: {
                cardView.transform = .identity
                cardView.layer.borderWidth = 1
                cardView.layer.borderColor = UIColor.gray.cgColor
            }, completion: nil)
        }
    }
    
    private func highlightStackTarget(_ stackView: TableauStackView) {
        UIView.animate(withDuration: 0.3, animations: {
            stackView.layer.borderColor = UIColor.yellow.cgColor
            stackView.layer.borderWidth = 3
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
                stackView.layer.borderColor = UIColor.white.cgColor
                stackView.layer.borderWidth = 2
            }, completion: nil)
        }
    }
    
    private func showToast(message: String, duration: Double = 2.0) {
        playToastSound(.noHintToast) // 🔈 Play sound
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width - 40, height: 40))
        toastLabel.center = CGPoint(x: self.frame.width / 2, y: self.frame.height - 100)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
    
    
    // MARK: Deal
    @objc func newDealAction() {
        if testModeEnabled {
            setupTestMode()  // ✅ Only do this
        } else {
            self.dealCards() // 🔁 fallback to normal
        }
    }
    
    private func dealCards() {
        Game.sharedInstance.initalizeDeal()
        
        moveCount = 0
        score = 0
        secondsElapsed = 0
        timer?.invalidate()
        timer = nil
        timerStarted = false
        updateStatsLabels()
        
        var tableauFrame = self.baseTableauFrameRect
        var cardValuesIndex = 0
        for outerIndex in 0 ..< 7 {
            self.tableauStackViews[outerIndex].frame = tableauFrame
            for innerIndex in (0 ... outerIndex) {
                Model.sharedInstance.tableauStacks[outerIndex].addCard(card: Card(value: Model.sharedInstance.deck[cardValuesIndex], faceUp: outerIndex == innerIndex))
                cardValuesIndex += 1
            }
            tableauFrame = tableauFrame.offsetBy(dx: CGFloat(CARD_WIDTH + SPACING), dy: 0.0)
        }
        
        for _ in cardValuesIndex ..< 52 {
            Model.sharedInstance.stockStack.addCard(card: Card(value: Model.sharedInstance.deck[cardValuesIndex], faceUp: false))
            cardValuesIndex += 1
        }
        let allViews = [stockStackView, talonStackView] + foundationStacks + tableauStackViews
        allViews.forEach { $0.refresh() }
    }
    
    private func setupTestMode() {
        print("✅ Test Mode Activated")

        // Clear all stacks
        Model.sharedInstance.foundationStacks.forEach { $0.removeAllCards() }
        Model.sharedInstance.tableauStacks.forEach { $0.removeAllCards() }
        Model.sharedInstance.talonStack.removeAllCards()
        Model.sharedInstance.stockStack.removeAllCards()

        let suitStartIndex = [
            0 * 13, // Spades
            1 * 13, // Diamonds
            2 * 13, // Hearts
            3 * 13  // Clubs
        ]

        var remainingCards: [Card] = []

        // Fill foundation A–8
        for (i, foundation) in Model.sharedInstance.foundationStacks.enumerated() {
            for j in 0...7 {
                let value = suitStartIndex[i] + j
                foundation.addCard(card: Card(value: value, faceUp: true))
            }

            // Remaining cards: 9,10,J,Q,K (8–12)
            for j in 8...12 {
                let value = suitStartIndex[i] + j
                remainingCards.append(Card(value: value, faceUp: true))
            }
        }

        // Shuffle remaining cards (optional)
        remainingCards.shuffle()

        // Distribute remaining cards across tableau and talon
        for (i, card) in remainingCards.enumerated() {
            if i % 2 == 0 && i / 2 < Model.sharedInstance.tableauStacks.count {
                Model.sharedInstance.tableauStacks[i / 2].addCard(card: card)
            } else {
                Model.sharedInstance.talonStack.addCard(card: card)
            }
        }

        // Refresh all views
        let allViews = [stockStackView, talonStackView] + foundationStacks + tableauStackViews
        allViews.forEach { $0.refresh() }
    }
}

extension SolitaireGameView: StockCardStackViewDelegate {
    func stockDidTap() {
        if !timerStarted {
            startTimer()
            timerStarted = true
        }
    }
}

// MARK: Handle dragging
extension SolitaireGameView {
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        let touch = touches.first!
        let tapCount = touch.tapCount
        if tapCount > 1 {
            handleDoubleTap(inView: touch.view!)
            return
        }
        
        if let touchedView = touch.view {
            Model.sharedInstance.dragStack.removeAllCards()
            dragView.removeAllCardViews()
            let touchPoint = touch.location(in: self)
            // we want the first view (in reverse order) that is visible and contains the touch point
            // create a drag view with this view, and other cards above it in the hierarchy, if any
            // the cards are removed from the stack during the drag, and then copied to either a new
            // stack or back to the originating stack.
            for cardView in touchedView.subviews.reversed() {
                if let cardView = cardView as? CardView {
                    let t = touch.location(in: cardView)
                    if cardView.isFaceUp && cardView.point(inside: t, with: event) {
                        stackDraggedFrom = touchedView as? CardStackView
                        let dragCard = Card(value: cardView.cardValue, faceUp: true)
                        if  let index = stackDraggedFrom!.cards.cards.firstIndex(where: { $0.value == dragCard.value })  {
                            // card that was touched
                            doingDrag = true
                            dragView.frame = cardView.convert(cardView.bounds, to: self)
                            self.addSubview(dragView)
                            Model.sharedInstance.dragStack.addCard(card: dragCard)
                            
                            // add any cards above it
                            if index < stackDraggedFrom!.cards.cards.endIndex - 1 {
                                for i in index + 1 ... stackDraggedFrom!.cards.cards.endIndex - 1 {
                                    let card = stackDraggedFrom!.cards.cards[i]
                                    Model.sharedInstance.dragStack.addCard(card: card)
                                }
                            }
                            
                            // the cards are now in the drag view so remove them from the stack
                            for card in Model.sharedInstance.dragStack.cards {
                                let index = stackDraggedFrom!.cards.cards.firstIndex { $0.value == card.value }
                                stackDraggedFrom!.cards.cards.remove(at: index!)
                            }
                            
                            stackDraggedFrom?.refresh()
                            dragView.refresh()
                            dragPosition = touchPoint
                            break
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard doingDrag else {
            return
        }
        
        if let touch = touches.first {
            let currentPosition = touch.location(in: self)
            
            let oldLocation = dragPosition
            dragPosition = currentPosition
            
            moveDragView(offset: CGPoint(x: (currentPosition.x) - (oldLocation.x), y: (currentPosition.y) - (oldLocation.y)))
        }
    }
    
    private func moveDragView(offset: CGPoint) {
        dragView.center = CGPoint(x: dragView.center.x + offset.x, y: dragView.center.y + offset.y)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        guard doingDrag else {
            return
        }
        
        dragView.cards.cards.forEach{ card in stackDraggedFrom!.cards.addCard(card: card) }
        dragView.removeFromSuperview()
        dragView.removeAllCardViews()
        
        dragView.bounds = CGRect.zero
        doingDrag = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if doingDrag {
            var done = false
            let dragFrame = dragView.convert(dragView.bounds, to: self)
            
            for view in tableauStackViews where view != stackDraggedFrom! {
                let viewFrame = view.convert(view.bounds, to: self)
                if viewFrame.intersects(dragFrame) {
                    // if a drop here is valid, move card and break out of loop
                    if view.cards.canAccept(droppedCard: dragView.cards.cards.first!) {
                        for card in Model.sharedInstance.dragStack.cards {
                            view.cards.addCard(card: card)
                            registerMove(points: 5)

                            if let stack = stackDraggedFrom as? TableauStackView {
                                stack.flipTopCard()
                                stack.refresh()
                            }
                        }
                        view.refresh()
                        done = true
                        break
                    }
                }
            }
            
            if (!done && dragView.cards.cards.count == 1) {
                let draggedCard = dragView.cards.cards.first!
                
                for (_, view) in foundationStacks.enumerated() where view != stackDraggedFrom! {
                    let viewFrame = view.convert(view.bounds, to: self)
                    
                    // ✅ Tightened hit test + logic check
                    if viewFrame.contains(dragPosition), view.cards.canAccept(droppedCard: draggedCard) {
                        view.cards.addCard(card: draggedCard)
                        
                        if let stack = stackDraggedFrom as? TableauStackView {
                            stack.flipTopCard()
                            stack.refresh()
                        }
                        
                        view.refresh()
                        registerMove(points: 10)
                        done = true
                        break
                    }
                }
            }
            
            if !done {
                // card(s) could be dropped, so put them back
                dragView.cards.cards.forEach{ card in stackDraggedFrom!.cards.addCard(card: card) }
                stackDraggedFrom?.refresh()

            }
            
            dragView.removeFromSuperview()
            dragView.removeAllCardViews()
            
            dragView.bounds = CGRect.zero
            doingDrag = false
        }
        playToastSound(.cardslide)

        if !timerStarted {
            startTimer()
            timerStarted = true
        }
        
        if allCardsAreFaceUp() {
            startAutoPlayToFoundation()
        }
        
        if checkWinCondition() {
            showWinAnimation()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.secondsElapsed += 1
            self.updateStatsLabels()
        }
    }
}

//MARK: HELPER METHODS
extension SolitaireGameView {
    private func allCardsAreFaceUp() -> Bool {
        return Model.sharedInstance.tableauStacks.allSatisfy { stack in
            stack.cards.allSatisfy { $0.faceUp }
        } && Model.sharedInstance.stockStack.cards.allSatisfy { $0.faceUp }
    }
    
    private func startAutoPlayToFoundation() {
        
        // Build list of candidate cards from tableau + talon
        var moves: [(from: CardDataStack, fromView: CardStackView, card: Card)] = []
        
        // 1. Tableau top cards
        for (index, tableau) in Model.sharedInstance.tableauStacks.enumerated() {
            if let card = tableau.topCard(), card.faceUp {
                let view = self.tableauStackViews[index]
                moves.append((from: tableau, fromView: view, card: card))
            }
        }
        
        // 2. Talon top card
        if let talonCard = Model.sharedInstance.talonStack.topCard(), talonCard.faceUp {
            moves.append((from: Model.sharedInstance.talonStack, fromView: self.talonStackView, card: talonCard))
        }
        
        guard !isAutoPlaying else { return }
        isAutoPlaying = true
        
        // Try moving each to foundation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.autoPlayMoveNext()
        }
    }
    
    //    private func autoPlayMoveNext(_ moves: [(from: CardDataStack, fromView: CardStackView, card: Card)]) {
    private func autoPlayMoveNext() {
        self.isAutoPlaying = false  // ✅ Reset autoplay flag
        
        // Build current top card candidates dynamically each step
        var candidates: [(stack: CardDataStack, view: CardStackView, card: Card)] = []
        
        // From tableau
        for (i, stack) in Model.sharedInstance.tableauStacks.enumerated() {
            if let card = stack.topCard(), card.faceUp {
                candidates.append((stack: stack, view: self.tableauStackViews[i], card: card))
            }
        }
        
        // From talon
        if let card = Model.sharedInstance.talonStack.topCard(), card.faceUp {
            candidates.append((stack: Model.sharedInstance.talonStack, view: self.talonStackView, card: card))
        }
        
        // Try moving one of them
        for candidate in candidates {
            for (i, foundationStack) in Model.sharedInstance.foundationStacks.enumerated() {
                if foundationStack.canAccept(droppedCard: candidate.card) {
                    let foundationView = self.foundationStacks[i]
                    
                    if let cardView = candidate.view.subviews.compactMap({ $0 as? CardView }).last(where: { $0.cardValue == candidate.card.value }) {
                        let snapshot = cardView.snapshotView(afterScreenUpdates: false)
                        snapshot?.frame = cardView.convert(cardView.bounds, to: self)
                        
                        if let snapshot = snapshot {
                            self.addSubview(snapshot)
                            self.playToastSound(.cardslide)
                            
                            UIView.animate(withDuration: 0.4, animations: {
                                snapshot.center = foundationView.center
                                snapshot.alpha = 0.1
                            }, completion: { _ in
                                snapshot.removeFromSuperview()
                                
                                // Move in model
                                candidate.stack.popCards(numberToPop: 1, makeNewTopCardFaceup: true)
                                foundationStack.addCard(card: candidate.card)
                                
                                candidate.view.refresh()
                                foundationView.refresh()
                                
                                self.registerMove(points: 10)

                                // Recurse to next move
                                self.startAutoPlayToFoundation()
                            })
                            return
                        }
                    }
                }
            }
        }
        
        // If no more moves available, check win
        if checkWinCondition() {
            showWinAnimation()
        }
    }
    
    
    
    private func checkWinCondition() -> Bool {
        return Model.sharedInstance.foundationStacks.allSatisfy { $0.cards.count == 13 }
    }
    
    private func showWinAnimation() {
        
        self.playToastSound(.gameWin)
        self.showWinAlert()
        
        // ⏹ Stop the timer
        timer?.invalidate()
        timer = nil
        
        // 🌧️ Smooth continuous rainfall
        let rainDuration: TimeInterval = 3.0
        let rainInterval: TimeInterval = 0.05 // new drop every 50ms
        let numberOfRaindrops = Int(rainDuration / rainInterval)
        
        for i in 0..<numberOfRaindrops {
            DispatchQueue.main.asyncAfter(deadline: .now() + rainInterval * Double(i)) {
                self.spawnRaindrop()
            }
        }
    }
    
    // 🌧️ Helper to spawn a single falling card snapshot
    private func spawnRaindrop() {
        let randomIndex = Int.random(in: 0..<Model.sharedInstance.cards.count)
        let cardView = Model.sharedInstance.cards[randomIndex]
        // ✅ Use false to prevent snapshot flicker
        guard let snapshot = cardView.snapshotView(afterScreenUpdates: false) else { return }
        
        let startX = CGFloat.random(in: 0...(self.bounds.width - CARD_WIDTH))
        let startY: CGFloat = -CARD_HEIGHT
        snapshot.frame = CGRect(x: startX, y: startY, width: CARD_WIDTH, height: CARD_HEIGHT)
        self.addSubview(snapshot)
        
        let fallDuration = TimeInterval.random(in: 2.0...4.0)
        let endY = self.bounds.height + CARD_HEIGHT
        
        UIView.animate(withDuration: fallDuration, delay: 0, options: [.curveEaseIn], animations: {
            snapshot.frame.origin.y = endY
            snapshot.alpha = 0.0
        }) { _ in
            snapshot.removeFromSuperview()
        }
    }
    
    
    private func showWinAlert() {
        let alert = UIAlertController(title: "You Win!", message: "Start a new deal?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Deal", style: .default, handler: { _ in
            self.delegate?.restartGame()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let vc = self.findViewController() {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
    
    private func registerMove(points: Int = 5) {
        moveCount += 1
        score += points
        updateStatsLabels()
    }
}

// MARK: Double Tap
extension SolitaireGameView {
    
    // if a card in the talon stack or one of the tableau stacks is double-tapped,
    // see if it can be added to a foundation stack
    // if you copy / paste these two functions and replace Foundation with Tableau
    // you can try moving them to a tableau stack if it doesn't go into a foundation stack
    // or, you can just let the user do something for themself :-)
    func handleDoubleTap(inView: UIView) {
        if !timerStarted {
            startTimer()
            timerStarted = true
        }
        
        if let talonStack = inView as? TalonCardStackView {
            if let card = talonStack.cards.topCard() {
                // Try to move to Foundation first
                if self.addCardToFoundation(card: card) {
                    talonStack.cards.popCards(numberToPop: 1, makeNewTopCardFaceup: true)
                    registerMove(points: 10)

                    return
                }
                
                // If not possible, try to move to any Tableau
                for tableau in tableauStackViews {
                    if tableau.cards.canAccept(droppedCard: card) {
                        tableau.cards.addCard(card: card)
                        Model.sharedInstance.talonStack.popCards(numberToPop: 1, makeNewTopCardFaceup: true)
                        registerMove(points: 5)

                        // Refresh both
                        tableau.refresh()
                        talonStack.refresh()
                        
                        return
                    }
                }
            }
        } else if let tableauStack = inView as? TableauStackView {
            // Try Foundation move first
            if let card = tableauStack.cards.topCard() {
                if self.addCardToFoundation(card: card) {
                    tableauStack.cards.popCards(numberToPop: 1, makeNewTopCardFaceup: true)
                    self.registerMove(points: 10)
                    return
                }
            }
            
            // Try Tableau → Tableau move
            handleTableauToTableauDoubleTap(from: tableauStack)
        }
    }
    
    private func handleTableauToTableauDoubleTap(from fromStack: TableauStackView) {
        let allCardViews = fromStack.subviews.compactMap { $0 as? CardView }
        let faceUpCardViews = allCardViews.filter { $0.isFaceUp }
        
        for (i, cardView) in faceUpCardViews.enumerated() {
            let card = Card(value: cardView.cardValue, faceUp: true)
            
            for toStack in tableauStackViews where toStack != fromStack {
                if toStack.cards.canAccept(droppedCard: card) {
                    // Get the slice of cards from this point onward
                    let movableCards = Array(fromStack.cards.cards.suffix(from: fromStack.cards.cards.count - faceUpCardViews.count + i))
                    
                    // Perform the move
                    movableCards.forEach { toStack.cards.addCard(card: $0) }
                    
                    // Remove from source
                    fromStack.cards.cards.removeLast(movableCards.count)
                    
                    // Flip new top card if needed
                    fromStack.flipTopCard()
                    
                    registerMove(points: 5)
                    
                    // Refresh
                    fromStack.refresh()
                    toStack.refresh()
                    
                    return
                }
            }
        }
    }
    
    
    private func addCardToFoundation(card: Card) -> Bool {
        var addedCard = false
        
        for stack in self.foundationStacks {
            if stack.cards.canAccept(droppedCard: card) {
                stack.cards.addCard(card: card)
                addedCard = true
                break
            }
        }
        
        return addedCard
    }
}
