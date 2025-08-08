import Foundation
import SpriteKit

class LevelManager {
    static let shared = LevelManager()
    
    private let userDefaults = UserDefaults.standard
    private let maxLevel = 6
    
    private init() {}
    
    // MARK: - Level Management
    
    func getCurrentLevel() -> Int {
        return userDefaults.integer(forKey: "CurrentLevel")
    }
    
    func setCurrentLevel(_ level: Int) {
        userDefaults.set(level, forKey: "CurrentLevel")
    }
    
    func getHighestUnlockedLevel() -> Int {
        return userDefaults.integer(forKey: "HighestUnlockedLevel")
    }
    
    func unlockLevel(_ level: Int) {
        let currentHighest = getHighestUnlockedLevel()
        if level > currentHighest {
            userDefaults.set(level, forKey: "HighestUnlockedLevel")
        }
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        return level <= getHighestUnlockedLevel()
    }
    
    func getMaxLevel() -> Int {
        return maxLevel
    }
    
    // MARK: - Score Management
    
    func getLevelScore(_ level: Int) -> Int {
        return userDefaults.integer(forKey: "LevelScore_\(level)")
    }
    
    func setLevelScore(_ level: Int, score: Int) {
        let currentScore = getLevelScore(level)
        if score > currentScore {
            userDefaults.set(score, forKey: "LevelScore_\(level)")
        }
    }
    
    func getTotalScore() -> Int {
        var total = 0
        for level in 1...maxLevel {
            total += getLevelScore(level)
        }
        return total
    }
    
    // MARK: - Game Progress
    
    func completeLevel(_ level: Int, score: Int) {
        setLevelScore(level, score: score)
        unlockLevel(level + 1)
        
        // Save completion status
        userDefaults.set(true, forKey: "LevelCompleted_\(level)")
    }
    
    func isLevelCompleted(_ level: Int) -> Bool {
        return userDefaults.bool(forKey: "LevelCompleted_\(level)")
    }
    
    // MARK: - Settings
    
    func getSoundEnabled() -> Bool {
        return userDefaults.bool(forKey: "SoundEnabled")
    }
    
    func setSoundEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: "SoundEnabled")
    }
    
    func getMusicEnabled() -> Bool {
        return userDefaults.bool(forKey: "MusicEnabled")
    }
    
    func setMusicEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: "MusicEnabled")
    }
    
    // MARK: - Level Data
    
    func getLevelData(_ level: Int) -> LevelData {
        switch level {
        case 1:
            return LevelData(
                title: "The Birth of Rama",
                description: "Begin your journey as Prince Rama",
                enemyCount: 5,
                enemyTypes: [.basic],
                powerUpCount: 2,
                backgroundTheme: .palace
            )
        case 2:
            return LevelData(
                title: "The Forest Exile",
                description: "Navigate through the dangerous forest",
                enemyCount: 8,
                enemyTypes: [.basic, .forest],
                powerUpCount: 3,
                backgroundTheme: .forest
            )
        case 3:
            return LevelData(
                title: "The Golden Deer",
                description: "Face the magical golden deer",
                enemyCount: 3,
                enemyTypes: [.golden, .boss],
                powerUpCount: 1,
                backgroundTheme: .golden
            )
        case 4:
            return LevelData(
                title: "Sita's Abduction",
                description: "Rescue Sita from Ravana",
                enemyCount: 6,
                enemyTypes: [.rakshasa, .boss],
                powerUpCount: 2,
                backgroundTheme: .lanka
            )
        case 5:
            return LevelData(
                title: "The Bridge to Lanka",
                description: "Build the bridge with Hanuman's help",
                enemyCount: 7,
                enemyTypes: [.forest, .rakshasa],
                powerUpCount: 3,
                backgroundTheme: .bridge
            )
        case 6:
            return LevelData(
                title: "The Final Battle",
                description: "Confront Ravana in the ultimate battle",
                enemyCount: 4,
                enemyTypes: [.boss, .rakshasa],
                powerUpCount: 2,
                backgroundTheme: .battle
            )
        default:
            return LevelData(
                title: "Unknown Level",
                description: "A mysterious challenge awaits",
                enemyCount: 5,
                enemyTypes: [.basic],
                powerUpCount: 2,
                backgroundTheme: .palace
            )
        }
    }
    
    // MARK: - Reset Game
    
    func resetGame() {
        userDefaults.removeObject(forKey: "CurrentLevel")
        userDefaults.removeObject(forKey: "HighestUnlockedLevel")
        
        // Reset all level scores
        for level in 1...maxLevel {
            userDefaults.removeObject(forKey: "LevelScore_\(level)")
            userDefaults.removeObject(forKey: "LevelCompleted_\(level)")
        }
        
        // Reset settings to defaults
        setSoundEnabled(true)
        setMusicEnabled(true)
    }
}

// MARK: - Supporting Types

struct LevelData {
    let title: String
    let description: String
    let enemyCount: Int
    let enemyTypes: [EnemyType]
    let powerUpCount: Int
    let backgroundTheme: BackgroundTheme
}

enum BackgroundTheme {
    case palace
    case forest
    case golden
    case lanka
    case bridge
    case battle
}
