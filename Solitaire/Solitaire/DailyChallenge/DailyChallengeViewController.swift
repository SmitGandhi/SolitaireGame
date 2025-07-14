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

    // Sample statuses
    private var playedDates: Set<String> = ["2025-07-12", "2025-07-13"]
    private var ongoingDate: String? = "2025-07-14"
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupCalendar()
    }

    private func setupCalendar() {
        calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = false
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        calendar.placeholderType = .none

        view.addSubview(calendar)

        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendar.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: - FSCalendarDataSource

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date <= Date() // ❌ Block future dates
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = dateFormatter.string(from: date)
        return playedDates.contains(key) ? 1 : 0
    }

    // MARK: - FSCalendarDelegateAppearance

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = dateFormatter.string(from: date)

        if ongoingDate == key {
            return .systemYellow  // 🟡 Ongoing
        } else if playedDates.contains(key) {
            return .systemBlue    // 🔵 Played
        } else if date < Date() {
            return .systemGray6   // ⚪️ Not played
        }

        return nil
    }


    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let key = dateFormatter.string(from: date)
        
        // Future dates → gray
        if date > Date() {
            return .lightGray
        }
        
        // Played dates → white
        if playedDates.contains(key) {
            return .white
        }
        
        // Not played past dates → black
        if date <= Date() && !playedDates.contains(key) {
            return .black
        }

        return .label
    }
}
