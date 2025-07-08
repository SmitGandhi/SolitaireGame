//
//  DailyChallengeViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 03/07/25.
//

import Foundation
import UIKit

class DailyChallengeViewController: UIViewController {

    // MARK: UI Components
    private let trophyImageView = UIImageView()
    private let monthLabel = UILabel()
    private let progressLabel = UILabel()
    private let calendarView: UICollectionView
    private let continueButton = UIButton(type: .system)
    private let dateLabel = UILabel()

    // MARK: Calendar Logic
    private let calendar = Calendar.current
    private var selectedMonthDate = Date()
    private var daysInMonth = 0
    private var firstWeekday = 0
    private var completedDays: Set<Int> = []
    private var selectedDay: Int?

    // MARK: Init
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.calendarView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHeader()
        setupCalendar()
        setupContinueButton()
        loadCompletedDays()
        calculateMonthLayout()
    }

    // MARK: Setup Views
    private func setupHeader() {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.spacing = 20
        view.addSubview(headerStack)

        // Trophy
        trophyImageView.image = UIImage(named: "trophy_disabled")
        trophyImageView.contentMode = .scaleAspectFit
        trophyImageView.setContentHuggingPriority(.required, for: .horizontal)
        trophyImageView.translatesAutoresizingMaskIntoConstraints = false
        trophyImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        trophyImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        // Month + Progress
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 8
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        monthLabel.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 28, weight: .bold))
        monthLabel.adjustsFontForContentSizeCategory = true
        monthLabel.textColor = .label
        monthLabel.numberOfLines = 2

        progressLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        progressLabel.adjustsFontForContentSizeCategory = true
        progressLabel.textColor = .white
        progressLabel.backgroundColor = .systemGray
        progressLabel.layer.cornerRadius = 10
        progressLabel.layer.masksToBounds = true
        progressLabel.textAlignment = .center
        progressLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        progressLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true

        labelStack.addArrangedSubview(monthLabel)
        labelStack.addArrangedSubview(progressLabel)

        headerStack.addArrangedSubview(labelStack)
        headerStack.addArrangedSubview(trophyImageView)

        view.addSubview(headerStack)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        let monthNavStack = UIStackView()
        monthNavStack.axis = .horizontal
        monthNavStack.alignment = .center
        monthNavStack.distribution = .equalSpacing
        monthNavStack.translatesAutoresizingMaskIntoConstraints = false

        let previousButton = UIButton(type: .system)
        previousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        previousButton.addTarget(self, action: #selector(goToPreviousMonth), for: .touchUpInside)

        let nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.addTarget(self, action: #selector(goToNextMonth), for: .touchUpInside)

        monthNavStack.addArrangedSubview(previousButton)
        monthNavStack.addArrangedSubview(monthLabel)
        monthNavStack.addArrangedSubview(nextButton)

        view.addSubview(monthNavStack)

        NSLayoutConstraint.activate([
            monthNavStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            monthNavStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            monthNavStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])

    }

    private func setupCalendar() {
        calendarView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "cell")
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.backgroundColor = .clear
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 30),
            calendarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 340)
        ])
    }

    private func setupContinueButton() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true
        view.addSubview(container)

        dateLabel.text = ""
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(dateLabel)

        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 8
        continueButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        container.addSubview(continueButton)

        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            container.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            continueButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            continueButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 180),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            continueButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])

        container.isHidden = true
    }
    
    @objc private func goToPreviousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: selectedMonthDate) else { return }
        selectedMonthDate = newDate
        loadCompletedDays()
        calculateMonthLayout()
    }

    @objc private func goToNextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: selectedMonthDate) else { return }
        
        // Optional: limit to current month only
        if newDate > Date() { return }

        selectedMonthDate = newDate
        loadCompletedDays()
        calculateMonthLayout()
    }

    // MARK: Game Launch & Trophy Logic
    @objc private func startGame() {
        guard let day = selectedDay else { return }

        let alert = UIAlertController(title: "Start Game", message: "Launch game for day \(day)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { _ in
            self.completedDays.insert(day)
            self.saveCompletedDays()
            self.selectedDay = nil
            self.calculateMonthLayout()
            self.continueButton.superview?.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func calculateMonthLayout() {
        let components = calendar.dateComponents([.year, .month], from: selectedMonthDate)
        let firstDay = calendar.date(from: components)!
        daysInMonth = calendar.range(of: .day, in: .month, for: firstDay)!.count
        firstWeekday = calendar.component(.weekday, from: firstDay) - 1

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy\nLLLL"
        monthLabel.text = formatter.string(from: selectedMonthDate)

        updateProgress()
        calendarView.reloadData()
    }

    private func updateProgress() {
        progressLabel.text = "\(completedDays.count)/\(daysInMonth)"
        if completedDays.count == daysInMonth {
            UIView.transition(with: trophyImageView, duration: 0.5, options: [.transitionFlipFromTop], animations: {
                self.trophyImageView.image = UIImage(named: "trophy_enabled")
            })
        }
    }

    private var completedDaysKey: String {
        let comps = calendar.dateComponents([.year, .month], from: selectedMonthDate)
        return "Completed-\(comps.year!)-\(comps.month!)"
    }

    private func saveCompletedDays() {
        UserDefaults.standard.set(Array(completedDays), forKey: completedDaysKey)
    }

    private func loadCompletedDays() {
        if let saved = UserDefaults.standard.array(forKey: completedDaysKey) as? [Int] {
            completedDays = Set(saved)
        }
    }

    private func formattedDate(for day: Int) -> String {
        var components = calendar.dateComponents([.year, .month], from: selectedMonthDate)
        components.day = day
        let date = calendar.date(from: components)!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func isPlayable(day: Int, in selectedMonth: Date) -> Bool {
        guard let cellDate = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: selectedMonth),
            month: calendar.component(.month, from: selectedMonth),
            day: day
        )) else { return false }

        return cellDate <= Date()
    }

}

// MARK: - UICollectionView
extension DailyChallengeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth + firstWeekday
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDayCell
            let day = indexPath.item - firstWeekday + 1
            let isValid = indexPath.item >= firstWeekday
            let isCompleted = completedDays.contains(day)
            let isToday = self.isToday(day)
            let isPlayable = isPlayable(day: day, in: selectedMonthDate)

            cell.configure(day: day, isValid: isValid, isCompleted: isCompleted, isToday: isToday, isPlayable: isPlayable)
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - firstWeekday + 1
        guard isPlayable(day: day, in: selectedMonthDate),
              !completedDays.contains(day) else { return }
        
        selectedDay = day
        dateLabel.text = formattedDate(for: day)
        continueButton.superview?.isHidden = false
    }

    func collectionView(_ collectionView: UICollectionView, layout layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 10 * 6
        let availableWidth = collectionView.bounds.width - totalSpacing
        let columns: CGFloat = traitCollection.horizontalSizeClass == .regular ? 9 : 7
        let width = availableWidth / columns
        return CGSize(width: width, height: width)
    }

    private func isToday(_ day: Int) -> Bool {
        let today = calendar.component(.day, from: Date())
        let month = calendar.component(.month, from: Date())
        let year = calendar.component(.year, from: Date())

        let selected = calendar.dateComponents([.year, .month], from: selectedMonthDate)
        return day == today && selected.month == month && selected.year == year
    }
}



class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        title = "Settings"
    }
}
