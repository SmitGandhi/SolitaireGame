//
//  DailyChallengeViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 03/07/25.
//

import Foundation
import UIKit
import FSCalendar

class DailyChallengeViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    private var calendar: FSCalendar!
    
    private var recordContainerView: UIView!
    private var recordLabel: UILabel!
    private var continueLabel: UILabel!
    private var continueButton: UIButton!
    var selectedDate:String = ""

    // Sample statuses
    private var playedDates: [String] = []// ["2025-07-12", "2025-07-13"]
    private var ongoingDate: String? = ""//"2025-07-14"
    private var summaryLabel: UILabel!
    
    private var playedDateKeys: Set<String> {
        ChallengeHistoryManager.shared.records
            .filter { $0.completed }
            .map { $0.dateKey }
            .reduce(into: Set<String>()) { $0.insert($1) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.updateBestOfMonth()
        calendar.reloadData()

        if let mainTab = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController {
            mainTab.hideCustomTabBar()
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = UIApplication.shared.windows.first?.rootViewController as? MainTabBarController {
            tabBarController.showCustomTabBar()
        }
    }

    private func setupCalendar() {
        // ✅ Summary Background Container
        let summaryContainer = UIView()
        summaryContainer.translatesAutoresizingMaskIntoConstraints = false
        summaryContainer.backgroundColor = .systemBackground
        summaryContainer.layer.cornerRadius = 12
        summaryContainer.layer.shadowColor = UIColor.black.cgColor
        summaryContainer.layer.shadowOpacity = 0.1
        summaryContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        summaryContainer.layer.shadowRadius = 4

        view.addSubview(summaryContainer)

        // ✅ Summary Label inside container
        summaryLabel = UILabel()
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.numberOfLines = 0
        summaryLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        summaryLabel.textAlignment = .center
        summaryLabel.textColor = .label

        summaryContainer.addSubview(summaryLabel)

        // ✅ Calendar Setup
        calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.placeholderType = .none
        calendar.appearance.weekdayTextColor = AppConstants.Colors.PrimaryButton
        calendar.appearance.weekdayFont = AppConstants.Fonts.MarkerFeltWide_14
        
        calendar.appearance.headerTitleColor = AppConstants.Colors.PrimaryButton
        calendar.appearance.headerTitleFont = AppConstants.Fonts.MarkerFeltWide_14

        view.addSubview(calendar)

        // MARK: Record Container
        recordContainerView = UIView()
        recordContainerView.translatesAutoresizingMaskIntoConstraints = false
        recordContainerView.backgroundColor = .secondarySystemBackground
        recordContainerView.layer.cornerRadius = 10
        recordContainerView.isHidden = true
        view.addSubview(recordContainerView)

        // Record Label
        recordLabel = UILabel()
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.numberOfLines = 0
        recordLabel.font = .systemFont(ofSize: 14)
        recordLabel.textAlignment = .center
        recordContainerView.addSubview(recordLabel)

        // Record Label
        continueLabel = UILabel()
        continueLabel.translatesAutoresizingMaskIntoConstraints = false
        continueLabel.numberOfLines = 0
        continueLabel.font = .systemFont(ofSize: 14)
        continueLabel.textAlignment = .center
        recordContainerView.addSubview(continueLabel)

        // Continue Button
        continueButton = UIButton(type: .system)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.appPrimaryButton(isEnable: true, title: "Continue", titleFont: AppConstants.Fonts.MarkerFeltThin_16!)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        recordContainerView.addSubview(continueButton)

        // ✅ Constraints
        NSLayoutConstraint.activate([
            // Summary container at top
            summaryContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            summaryContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            summaryContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Summary label inside
            summaryLabel.topAnchor.constraint(equalTo: summaryContainer.topAnchor, constant: 12),
            summaryLabel.bottomAnchor.constraint(equalTo: summaryContainer.bottomAnchor, constant: -12),
            summaryLabel.leadingAnchor.constraint(equalTo: summaryContainer.leadingAnchor, constant: 12),
            summaryLabel.trailingAnchor.constraint(equalTo: summaryContainer.trailingAnchor, constant: -12),
            
            // Calendar below summary
            calendar.topAnchor.constraint(equalTo: summaryContainer.bottomAnchor, constant: 20),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendar.heightAnchor.constraint(equalToConstant: 300),
            
            // Container below calendar
            recordContainerView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            recordContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Record label
            recordLabel.topAnchor.constraint(equalTo: recordContainerView.topAnchor, constant: 12),
            recordLabel.leadingAnchor.constraint(equalTo: recordContainerView.leadingAnchor, constant: 12),
            recordLabel.trailingAnchor.constraint(equalTo: recordContainerView.trailingAnchor, constant: -12),
            recordLabel.bottomAnchor.constraint(equalTo: recordContainerView.bottomAnchor, constant: -12),
            
            // Record label
            continueLabel.topAnchor.constraint(equalTo: recordContainerView.topAnchor, constant: 12),
            continueLabel.leadingAnchor.constraint(equalTo: recordContainerView.leadingAnchor, constant: 12),
            continueLabel.trailingAnchor.constraint(equalTo: recordContainerView.trailingAnchor, constant: -12),
//            continueLabel.bottomAnchor.constraint(equalTo: recordContainerView.bottomAnchor, constant: -12),

            // Continue button
            continueButton.topAnchor.constraint(equalTo: continueLabel.bottomAnchor, constant: 12),
            continueButton.centerXAnchor.constraint(equalTo: recordContainerView.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 140),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.bottomAnchor.constraint(equalTo: recordContainerView.bottomAnchor, constant: -12)
        ])
    }

    
    // MARK: - FSCalendarDataSource

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let key = DateFormatter.standardKeyFormat.string(from: date)

        if playedDateKeys.contains(key) {
            //Show the records
            
            return true
        }else if date <= Date() {
            //Show continue button
            return true
        }
        return false
    }
    
    @objc private func continueTapped() {
        guard let date = calendar.selectedDate else { return }
        let key = DateFormatter.standardKeyFormat.string(from: date)
        
        // 🕹 Start game for the selected date
        print("👉 Launch game for date: \(key)")
        
        // Push your GameViewController with selected date passed
        let solitaireGameViewController = SolitaireGameViewController()
        solitaireGameViewController.gameDate = selectedDate
        self.navigationController?.pushViewController(solitaireGameViewController, animated: true)
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = DateFormatter.standardKeyFormat.string(from: date)
        return playedDates.contains(key) ? 1 : 0
    }

    // MARK: - FSCalendarDelegateAppearance

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = DateFormatter.standardKeyFormat.string(from: date)
        
        if ongoingDate == key {
            return .systemYellow  // 🟡 Ongoing
        } else if playedDates.contains(key) {
            return AppConstants.Colors.PrimaryButton    // 🔵 Played
        } else if date < Date() {
            return .systemGray6   // ⚪️ Not played
        }

        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let key = DateFormatter.standardKeyFormat.string(from: date)
        recordContainerView.isHidden = false

        if let record = ChallengeHistoryManager.shared.records.first(where: { $0.dateKey == key }) {
            // ✅ Already played
            recordLabel.text = """
            🧠 Moves: \(record.moves)
            ⏱ Time: \(record.timeInSeconds) sec
            💰 Score: \(record.score)
            """
            continueButton.isHidden = true
            continueLabel.isHidden = true
            recordLabel.isHidden = false
        } else if date <= Date() {
            // ✅ Not played
            selectedDate = key
            continueLabel.text = "You haven’t played this day yet."
            continueButton.isHidden = false
            continueLabel.isHidden = false
            recordLabel.isHidden = true
        } else {
            // Future date
            recordContainerView.isHidden = true
            
        }
    }


    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let key = DateFormatter.standardKeyFormat.string(from: date)

        if playedDateKeys.contains(key){
            return .white
        }else if date > Date() {
            return .lightGray  // Visually disabled
        }

        return .black
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateBestOfMonth()
    }

    private func updateBestOfMonth() {
        
        playedDates = ChallengeHistoryManager.shared.records
            .filter { $0.completed }
            .map { $0.dateKey }

        let best = ChallengeHistoryManager.shared.bestOfMonth(for: calendar.currentPage)

        let text = """
        🏆 Best Time: \(best.bestTime?.timeInSeconds ?? 0)s On: \(best.bestTime?.dateKey ?? "")
        🧠 Least Moves: \(best.bestMoves?.moves ?? 0) On: \(best.bestMoves?.dateKey ?? "")
        💰 Highest Score: \(best.bestScore?.score ?? 0) On: \(best.bestScore?.dateKey ?? "")
        """
        summaryLabel.text = text
        
    }

}
