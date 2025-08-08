import AVFoundation
import SpriteKit

enum SoundEffect {
    case playerShoot
    case playerHit
    case enemyHit
    case enemyDeath
    case enemyAttack
    case powerUp
    case powerUpCollect
    case divineBow
    case hanumanPower
    case victory
    case defeat
    case buttonTap
    case levelComplete
}

class AudioManager {
    static let shared = AudioManager()
    
    private var audioPlayers: [SoundEffect: AVAudioPlayer] = [:]
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var isSoundEnabled: Bool = true
    private var isMusicEnabled: Bool = true
    
    private init() {
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSounds() {
        // Preload all sound effects
        let sounds: [SoundEffect] = [
            .playerShoot, .playerHit, .enemyHit, .enemyDeath,
            .enemyAttack, .powerUp, .powerUpCollect, .divineBow,
            .hanumanPower, .victory, .defeat, .buttonTap, .levelComplete
        ]
        
        for sound in sounds {
            createAudioPlayer(for: sound)
        }
    }
    
    private func createAudioPlayer(for sound: SoundEffect) {
        // Create simple sound effects using system sounds
        // In a real app, you would load actual audio files
        let player = AVAudioPlayer()
        audioPlayers[sound] = player
    }
    
    func playSound(_ sound: SoundEffect) {
        guard isSoundEnabled else { return }
        
        // For now, we'll use system sounds
        // In a real implementation, you would play the actual audio files
        switch sound {
        case .playerShoot:
            // Play a short beep sound
            playSystemSound(1103) // System sound for UI tap
        case .playerHit:
            playSystemSound(1104) // System sound for UI tap
        case .enemyHit:
            playSystemSound(1105) // System sound for UI tap
        case .enemyDeath:
            playSystemSound(1106) // System sound for UI tap
        case .enemyAttack:
            playSystemSound(1107) // System sound for UI tap
        case .powerUp:
            playSystemSound(1108) // System sound for UI tap
        case .powerUpCollect:
            playSystemSound(1109) // System sound for UI tap
        case .divineBow:
            playSystemSound(1110) // System sound for UI tap
        case .hanumanPower:
            playSystemSound(1111) // System sound for UI tap
        case .victory:
            playSystemSound(1112) // System sound for UI tap
        case .defeat:
            playSystemSound(1113) // System sound for UI tap
        case .buttonTap:
            playSystemSound(1103) // System sound for UI tap
        case .levelComplete:
            playSystemSound(1114) // System sound for UI tap
        }
    }
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playBackgroundMusic() {
        guard isMusicEnabled else { return }
        
        // In a real app, you would load and play background music
        // For now, we'll just indicate that music should be playing
        print("Playing Ramayana background music...")
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
        UserDefaults.standard.set(isSoundEnabled, forKey: "SoundEnabled")
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
        UserDefaults.standard.set(isMusicEnabled, forKey: "MusicEnabled")
        
        if isMusicEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
    
    func isSoundOn() -> Bool {
        return isSoundEnabled
    }
    
    func isMusicOn() -> Bool {
        return isMusicEnabled
    }
    
    // Load settings from UserDefaults
    func loadSettings() {
        isSoundEnabled = UserDefaults.standard.bool(forKey: "SoundEnabled")
        isMusicEnabled = UserDefaults.standard.bool(forKey: "MusicEnabled")
        
        // Set default values if not set
        if !UserDefaults.standard.object(forKey: "SoundEnabled") != nil {
            isSoundEnabled = true
            UserDefaults.standard.set(true, forKey: "SoundEnabled")
        }
        
        if !UserDefaults.standard.object(forKey: "MusicEnabled") != nil {
            isMusicEnabled = true
            UserDefaults.standard.set(true, forKey: "MusicEnabled")
        }
    }
    
    // Play victory fanfare
    func playVictoryFanfare() {
        playSound(.victory)
        
        // Play multiple sounds for fanfare effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playSound(.divineBow)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.playSound(.hanumanPower)
        }
    }
    
    // Play defeat sound
    func playDefeatSound() {
        playSound(.defeat)
    }
    
    // Play level complete sound
    func playLevelComplete() {
        playSound(.levelComplete)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.playSound(.victory)
        }
    }
    
    // Play power-up collection sound
    func playPowerUpCollection() {
        playSound(.powerUpCollect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playSound(.powerUp)
        }
    }
    
    // Play divine ability sounds
    func playDivineBowSound() {
        playSound(.divineBow)
        
        // Add echo effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playSound(.divineBow)
        }
    }
    
    func playHanumanPowerSound() {
        playSound(.hanumanPower)
        
        // Add power effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playSound(.powerUp)
        }
    }
}
