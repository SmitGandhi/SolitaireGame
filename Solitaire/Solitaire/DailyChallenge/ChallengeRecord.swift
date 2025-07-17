//
//  ChallengeRecord.swift
//  Solitaire
//
//  Created by Smit Gandhi on 15/07/25.
//


import Foundation

struct ChallengeRecord: Codable {
    let dateKey: String     // "yyyy-MM-dd"
    let completed: Bool
    let score: Int
    let moves: Int
    let timeInSeconds: Int
}
