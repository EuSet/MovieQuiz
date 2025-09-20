//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Евгений Сецко on 18.09.25.
//

import Foundation

private enum Keys: String {
    case gamesCount
    case bestGame
    case totalCorrectAnswers
    case totalQuestionsAsked
}

class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    var bestGame: GameResult {
        get {
            return self.getBestGameResult()
        }
    }
    
    var gamesCount: Int {
        get {
            self.getGamesCount()
        }
    }
    
    var totalAccuracy: Double {
        get {
            return self.calculateTotalAccuracy()
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        storeBestGameResult(correct: count, total: amount)
        storeGamesCount()
        storeTotalAccuracy(correct: count, total: amount)
    }
    
    private func getBestGameResult() -> GameResult {
        let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue)
        if let data, let savedGame = try? JSONDecoder().decode(GameResult.self, from: data) {
            return savedGame
        } else {
            return GameResult(correct: 0, total: 0, date: Date())
        }
    }
    
    private func storeBestGameResult(correct count: Int, total amount: Int) {
        let gameResult = GameResult(correct: count, total: amount, date: Date())
        if gameResult.checkIsBetterThan(result: bestGame) {
            if let encoded = try? JSONEncoder().encode(gameResult) {
                storage.set(encoded, forKey: Keys.bestGame.rawValue)
            }
        }
    }
    
    private func calculateTotalAccuracy() -> Double {
        let totalCorrectAnswers = storage.double(forKey: Keys.totalCorrectAnswers.rawValue)
        let totalQuestionsAsked = storage.double(forKey: Keys.totalQuestionsAsked.rawValue)
        return 100 / totalQuestionsAsked * totalCorrectAnswers
    }
    
    private func storeTotalAccuracy(correct count: Int, total amount: Int) {
        let totalCorrectAnswers = storage.double(forKey: Keys.totalCorrectAnswers.rawValue)
        let totalQuestionsAsked = storage.double(forKey: Keys.totalQuestionsAsked.rawValue)
        storage.set(totalCorrectAnswers + Double(count), forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(totalQuestionsAsked + Double(amount), forKey: Keys.totalQuestionsAsked.rawValue)
    }
    
    private func getGamesCount() -> Int {
        return storage.integer(forKey: Keys.gamesCount.rawValue)
    }
    
    private func storeGamesCount() {
        storage.set(self.gamesCount + 1, forKey:Keys.gamesCount.rawValue)
    }
    
    init() {}
    
    
}
