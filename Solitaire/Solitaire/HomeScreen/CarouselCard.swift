//
//  CardType.swift
//  Solitaire
//
//  Created by Smit Gandhi on 08/07/25.
//


import Foundation

enum CardType {
    case dailyChallenge
    case random
    case timer
}

struct CarouselCard {
    let type: CardType
    let title: String
    let subtitle: String
    let buttonTitle: String?
    let timer: String?
    let imageName: String
}
