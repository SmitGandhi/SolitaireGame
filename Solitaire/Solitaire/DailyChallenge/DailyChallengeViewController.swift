//
//  DailyChallengeViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 03/07/25.
//

import Foundation
import UIKit

class DailyChallengeViewController: UIViewController {

    private let trophyImageView = UIImageView()
    private var calendarView: UICollectionView!
    private var completedDays: Set<Int> = [] // store completed day numbers like [1, 2, 3]
    
    private let currentDate = Date()
    private var calendar = Calendar.current
    private var daysInMonth: Int = 0
    private var firstWeekday: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTrophy()
        setupCalendar()
        calculateMonthLayout()
    }

    private func setupTrophy() {
        trophyImageView.image = UIImage(named: "trophy_disabled")
        trophyImageView.contentMode = .scaleAspectFit
        trophyImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trophyImageView)

        NSLayoutConstraint.activate([
            trophyImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            trophyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trophyImageView.heightAnchor.constraint(equalToConstant: 60),
            trophyImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupCalendar() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        calendarView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        calendarView.backgroundColor = .clear
        view.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: trophyImageView.bottomAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }

    private func calculateMonthLayout() {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let firstDayOfMonth = calendar.date(from: components)!
        daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
        firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
    }

    private func isDatePlayable(day: Int) -> Bool {
        let today = calendar.component(.day, from: currentDate)
        return day <= today
    }

    private func checkTrophyStatus() {
        if completedDays.count == daysInMonth {
            trophyImageView.image = UIImage(named: "trophy_enabled")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DailyChallengeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth + firstWeekday
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath)
        
        for sub in cell.contentView.subviews { sub.removeFromSuperview() }

        let label = UILabel(frame: cell.contentView.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)

        let day = indexPath.item - firstWeekday + 1
        if indexPath.item < firstWeekday {
            label.text = ""
        } else {
            label.text = "\(day)"
            if completedDays.contains(day) {
                cell.contentView.backgroundColor = .systemGreen
            } else if isDatePlayable(day: day) {
                cell.contentView.backgroundColor = .systemBlue
            } else {
                cell.contentView.backgroundColor = .systemGray4
            }
        }

        label.textColor = .white
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        cell.contentView.addSubview(label)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - firstWeekday + 1
        guard day > 0, isDatePlayable(day: day) else { return }

        // Mark this day as completed
        completedDays.insert(day)
        calendarView.reloadData()
        checkTrophyStatus()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 6 * 4) / 7
        return CGSize(width: width, height: width)
    }
}


class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        title = "Settings"
    }
}
