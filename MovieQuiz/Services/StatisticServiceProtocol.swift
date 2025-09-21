//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Евгений Сецко on 18.09.25.
//

import Foundation

struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func checkIsBetterThan(result: GameResult) -> Bool {
        let currentBestAccuracy = result.total > 0
        ? Double(result.correct) / Double(result.total)
        : 0
        
        let newAccuracy = self.total > 0
        ? Double(self.correct) / Double(self.total)
        : 0
        
        return newAccuracy > currentBestAccuracy
    }
}

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
