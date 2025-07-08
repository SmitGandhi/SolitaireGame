//
//  CalendarDayCell.swift
//  Solitaire
//
//  Created by Smit Gandhi on 04/07/25.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {

    private let dayLabel = UILabel()
    private let statusImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dayLabel.textAlignment = .center
        dayLabel.textColor = .label
        contentView.addSubview(dayLabel)

        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.contentMode = .scaleAspectFit
        contentView.addSubview(statusImageView)

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            statusImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            statusImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            statusImageView.widthAnchor.constraint(equalToConstant: 28),
            statusImageView.heightAnchor.constraint(equalToConstant: 28),
            statusImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(day: Int, isValid: Bool, isCompleted: Bool, isToday: Bool, isPlayable: Bool) {
        guard isValid else {
            dayLabel.text = ""
            contentView.backgroundColor = .clear
            statusImageView.image = nil
            return
        }

        dayLabel.text = "\(day)"

        if isCompleted {
            contentView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
            dayLabel.textColor = .white
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            statusImageView.tintColor = .white
        }
        else if isToday {
            contentView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.9)
            dayLabel.textColor = .white
            statusImageView.image = UIImage(systemName: "circle.fill")
            statusImageView.tintColor = .white
        }
        else if isPlayable {
            contentView.backgroundColor = .clear
//            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
            dayLabel.textColor = .systemBlue
            statusImageView.image = UIImage(systemName: "gamecontroller.fill")
            statusImageView.tintColor = .systemBlue
        }
        else {
            contentView.backgroundColor = .clear
            contentView.layer.borderWidth = 0
            dayLabel.textColor = .systemGray2
//            statusImageView.image = UIImage(systemName: "lock.fill")
//            statusImageView.tintColor = .systemGray3
        }
    }


    private func isPlayable(day: Int) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: now)

        guard let currentDay = currentComponents.day else { return false }
        let todayMonth = currentComponents.month!
        let todayYear = currentComponents.year!

        // Get the date this cell represents
        if let cellDate = calendar.date(from: DateComponents(year: todayYear, month: todayMonth, day: day)) {
            return cellDate <= now
        }

        return false
    }
}
