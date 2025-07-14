//
//  ButtonCell.swift
//  Solitaire
//
//  Created by Smit Gandhi on 09/07/25.
//

import UIKit
import Foundation

class ButtonCell: UITableViewCell {

    let button = UIButton(type: .system)
    var buttonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func handleTap() {
        buttonAction?()
    }

    func configure(title: String, backgroundColor: UIColor, action: (() -> Void)? = nil) {
        button.appPrimaryButton(isEnable: true, title: title, titleFont: AppConstants.Fonts.MarkerFeltThin_16!)
        self.buttonAction = action
    }
}
