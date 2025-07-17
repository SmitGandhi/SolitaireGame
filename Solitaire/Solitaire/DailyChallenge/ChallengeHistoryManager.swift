//
//  ChallengeHistoryManager.swift
//  Solitaire
//
//  Created by Smit Gandhi on 15/07/25.
//

import Foundation

class ChallengeHistoryManager {
    static let shared = ChallengeHistoryManager()
    private let key = "ChallengeRecords"

    private(set) var records: [ChallengeRecord] = []

    private init() {
        load()
    }

    func saveRecord(_ record: ChallengeRecord) {
        if let index = records.firstIndex(where: { $0.dateKey == record.dateKey }) {
            records[index] = record
        } else {
            records.append(record)
        }
        save()
    }

    func bestOfMonth(for month: Date) -> (bestTime: ChallengeRecord?, bestMoves: ChallengeRecord?, bestScore: ChallengeRecord?) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)

        let monthRecords = records.filter {
            
            guard let date = DateFormatter.standardKeyFormat.date(from: $0.dateKey) else { return false }

            let dateComp = calendar.dateComponents([.year, .month], from: date)
            return dateComp.year == components.year && dateComp.month == components.month && $0.completed
        }

        let bestTime = monthRecords.min(by: { $0.timeInSeconds < $1.timeInSeconds })
        let bestMoves = monthRecords.min(by: { $0.moves < $1.moves })
        let bestScore = monthRecords.max(by: { $0.score < $1.score })

        return (bestTime, bestMoves, bestScore)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([ChallengeRecord].self, from: data) {
            self.records = decoded
        }
    }
}
