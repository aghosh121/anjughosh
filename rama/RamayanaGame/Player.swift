import SpriteKit
import GameplayKit

class Player: SKSpriteNode {
    
    var health: Int = 100
    var maxHealth: Int = 100
    var powerLevel: Int = 1
    var isInvulnerable: Bool = false
    
    // Power-up effects
    private var activePowerUps: [PowerUpType: TimeInterval] = [:]
    private var lastShotTime: TimeInterval = 0
    private let shotCooldown: TimeInterval = 0.3
    
    // Physics categories
    let playerCategory: UInt32 = 0x1 << 0
    
    init() {
        // Create Rama's visual representation
        let texture = createRamaTexture()
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 60))
        
        setupPhysics()
        setupAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createRamaTexture() -> SKTexture {
        // Create a simple Rama character with divine colors
        let size = CGSize(width: 40, height: 60)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw Rama's body (blue - divine color)
        context.setFillColor(UIColor.systemBlue.cgColor)
        context.fillEllipse(in: CGRect(x: 8, y: 20, width: 24, height: 30))
        
        // Draw Rama's head (golden)
        context.setFillColor(UIColor.systemYellow.cgColor)
        context.fillEllipse(in: CGRect(x: 12, y: 40, width: 16, height: 16))
        
        // Draw Rama's bow (brown)
        context.setFillColor(UIColor.brown.cgColor)
        context.fill(CGRect(x: 35, y: 25, width: 4, height: 20))
        
        // Draw Rama's crown (golden)
        context.setFillColor(UIColor.systemYellow.cgColor)
        context.fill(CGRect(x: 10, y: 55, width: 20, height: 4))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image)
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody?.categoryBitMask = playerCategory
        physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 2 // Enemy and PowerUp categories
        physicsBody?.collisionBitMask = 0
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
    }
    
    private func setupAnimations() {
        // Add a subtle glow effect
        let glow = SKEmitterNode()
        glow.particleBirthRate = 5
        glow.particleLifetime = 2.0
        glow.particleSpeed = 10
        glow.particleSpeedRange = 5
        glow.particleAlpha = 0.3
        glow.particleAlphaRange = 0.2
        glow.particleScale = 0.1
        glow.particleScaleRange = 0.05
        glow.particleColor = .yellow
        glow.position = CGPoint(x: 0, y: 0)
        glow.zPosition = -1
        addChild(glow)
        
        // Add floating animation
        let floatUp = SKAction.moveBy(x: 0, y: 5, duration: 1.0)
        let floatDown = SKAction.moveBy(x: 0, y: -5, duration: 1.0)
        let floatSequence = SKAction.sequence([floatUp, floatDown])
        run(SKAction.repeatForever(floatSequence))
    }
    
    func takeDamage(_ damage: Int) {
        if isInvulnerable { return }
        
        health = max(0, health - damage)
        
        // Visual feedback
        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        run(flash)
        
        // Temporary invulnerability
        isInvulnerable = true
        let invulnerabilityTimer = SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                self?.isInvulnerable = false
            }
        ])
        run(invulnerabilityTimer)
        
        // Play damage sound effect
        AudioManager.shared.playSound(.playerHit)
    }
    
    func applyPowerUp(_ type: PowerUpType) {
        activePowerUps[type] = Date().timeIntervalSince1970 + 10.0 // 10 seconds duration
        
        switch type {
        case .health:
            health = min(maxHealth, health + 30)
        case .speed:
            // Speed boost will be handled in update
            break
        case .power:
            powerLevel += 1
        case .shield:
            isInvulnerable = true
            let shieldTimer = SKAction.sequence([
                SKAction.wait(forDuration: 5.0),
                SKAction.run { [weak self] in
                    self?.isInvulnerable = false
                }
            ])
            run(shieldTimer)
        }
        
        // Visual power-up effect
        let powerUpEffect = SKEmitterNode()
        powerUpEffect.particleBirthRate = 20
        powerUpEffect.particleLifetime = 1.0
        powerUpEffect.particleSpeed = 50
        powerUpEffect.particleSpeedRange = 20
        powerUpEffect.particleAlpha = 0.8
        powerUpEffect.particleAlphaRange = 0.2
        powerUpEffect.particleScale = 0.2
        powerUpEffect.particleScaleRange = 0.1
        powerUpEffect.particleColor = .white
        powerUpEffect.position = CGPoint(x: 0, y: 0)
        powerUpEffect.zPosition = 1
        addChild(powerUpEffect)
        
        let removeEffect = SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
        ])
        powerUpEffect.run(removeEffect)
        
        // Play power-up sound
        AudioManager.shared.playSound(.powerUp)
    }
    
    func canShoot() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        return currentTime - lastShotTime >= shotCooldown
    }
    
    func shoot() {
        lastShotTime = Date().timeIntervalSince1970
        AudioManager.shared.playSound(.playerShoot)
    }
    
    func update(_ currentTime: TimeInterval) {
        // Update power-up timers
        let currentTimeInterval = Date().timeIntervalSince1970
        activePowerUps = activePowerUps.filter { type, expirationTime in
            if currentTimeInterval >= expirationTime {
                // Power-up expired
                switch type {
                case .speed:
                    // Reset speed
                    break
                case .power:
                    powerLevel = max(1, powerLevel - 1)
                default:
                    break
                }
                return false
            }
            return true
        }
        
        // Apply speed boost if active
        if activePowerUps[.speed] != nil {
            // Speed boost is active
            // This would affect movement speed in the game scene
        }
    }
    
    func getPowerLevel() -> Int {
        return powerLevel
    }
    
    func getHealthPercentage() -> CGFloat {
        return CGFloat(health) / CGFloat(maxHealth)
    }
    
    // Special abilities based on Ramayana
    func useDivineBow() {
        // Rama's divine bow ability
        AudioManager.shared.playSound(.divineBow)
        
        // Create multiple projectiles
        for i in -2...2 {
            let angle = CGFloat(i) * CGFloat.pi / 6
            // This would create a spread shot effect
        }
    }
    
    func useHanumanPower() {
        // Hanuman's strength power-up
        AudioManager.shared.playSound(.hanumanPower)
        
        // Temporary massive power boost
        powerLevel += 3
        let resetTimer = SKAction.sequence([
            SKAction.wait(forDuration: 5.0),
            SKAction.run { [weak self] in
                self?.powerLevel = max(1, self?.powerLevel ?? 1 - 3)
            }
        ])
        run(resetTimer)
    }
}
