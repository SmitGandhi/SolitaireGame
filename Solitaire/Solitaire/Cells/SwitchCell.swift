//
//  SwitchCell.swift
//  Solitaire
//
//  Created by Smit Gandhi on 09/07/25.
//

import UIKit
import Foundation

class SwitchCell: UITableViewCell {

    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let toggleSwitch = UISwitch()

    // 🔁 Closure to send toggle updates
    var switchChanged: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = AppConstants.Fonts.MarkerFeltWide_16
        
        iconImageView.tintColor = AppConstants.Colors.TabColor
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)

        toggleSwitch.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func toggleChanged(_ sender: UISwitch) {
        switchChanged?(sender.isOn)  // 🔥 Callback
    }

    func configure(with title: String, isOn: Bool, symbolName: String, onToggleChanged: ((Bool) -> Void)?) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
        iconImageView.image = UIImage(systemName: symbolName)
        self.switchChanged = onToggleChanged
    }
}
