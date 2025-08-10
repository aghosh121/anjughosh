import SpriteKit
import GameplayKit

enum EnemyType {
    case basic      // Simple demons
    case forest     // Forest creatures
    case boss       // Boss enemies like Ravana
    case rakshasa   // Powerful demons
    case golden     // Golden deer (special)
}

class Enemy: SKSpriteNode {
    
    var health: Int = 50
    var maxHealth: Int = 50
    var damage: Int = 10
    var speed: CGFloat = 50.0
    var type: EnemyType
    var isAlive: Bool = true
    
    // AI behavior
    private var targetPosition: CGPoint?
    private var lastAttackTime: TimeInterval = 0
    private var attackCooldown: TimeInterval = 2.0
    private var movementPattern: MovementPattern = .patrol
    
    // Physics categories
    let enemyCategory: UInt32 = 0x1 << 1
    
    enum MovementPattern {
        case patrol
        case chase
        case circle
        case stationary
    }
    
    init(type: EnemyType) {
        self.type = type
        let texture = createEnemyTexture(for: type)
        super.init(texture: texture, color: .clear, size: getEnemySize(for: type))
        
        setupEnemyProperties()
        setupPhysics()
        setupAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .basic
        super.init(coder: aDecoder)
    }
    
    private func createEnemyTexture(for type: EnemyType) -> SKTexture {
        let size = getEnemySize(for: type)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        switch type {
        case .basic:
            // Simple demon - red
            context.setFillColor(UIColor.systemRed.cgColor)
            context.fillEllipse(in: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
            
            // Eyes
            context.setFillColor(UIColor.white.cgColor)
            context.fillEllipse(in: CGRect(x: 8, y: 12, width: 6, height: 6))
            context.fillEllipse(in: CGRect(x: 16, y: 12, width: 6, height: 6))
            
        case .forest:
            // Forest creature - green
            context.setFillColor(UIColor.systemGreen.cgColor)
            context.fillEllipse(in: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
            
            // Spikes
            context.setFillColor(UIColor.darkGreen.cgColor)
            for i in 0..<5 {
                let x = CGFloat(i) * 4 + 2
                context.fill(CGRect(x: x, y: 0, width: 2, height: 8))
            }
            
        case .boss:
            // Boss enemy - purple
            context.setFillColor(UIColor.systemPurple.cgColor)
            context.fillEllipse(in: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
            
            // Crown
            context.setFillColor(UIColor.systemYellow.cgColor)
            context.fill(CGRect(x: 8, y: size.height - 8, width: size.width - 16, height: 4))
            
        case .rakshasa:
            // Rakshasa - dark red
            context.setFillColor(UIColor.systemRed.cgColor)
            context.fillEllipse(in: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
            
            // Horns
            context.setFillColor(UIColor.brown.cgColor)
            context.fill(CGRect(x: 8, y: size.height - 12, width: 3, height: 8))
            context.fill(CGRect(x: 19, y: size.height - 12, width: 3, height: 8))
            
        case .golden:
            // Golden deer - golden
            context.setFillColor(UIColor.systemYellow.cgColor)
            context.fillEllipse(in: CGRect(x: 5, y: 5, width: size.width - 10, height: size.height - 10))
            
            // Antlers
            context.setFillColor(UIColor.brown.cgColor)
            context.fill(CGRect(x: 8, y: size.height - 15, width: 2, height: 12))
            context.fill(CGRect(x: 20, y: size.height - 15, width: 2, height: 12))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image)
    }
    
    private func getEnemySize(for type: EnemyType) -> CGSize {
        switch type {
        case .basic:
            return CGSize(width: 6, height: 6)
        case .forest:
            return CGSize(width: 8, height: 8)
        case .boss:
            return CGSize(width: 12, height: 12)
        case .rakshasa:
            return CGSize(width: 7, height: 7)
        case .golden:
            return CGSize(width: 9, height: 9)
        }
    }
    
    private func setupEnemyProperties() {
        switch type {
        case .basic:
            health = 30
            maxHealth = 30
            damage = 10
            speed = 40.0
            movementPattern = .patrol
            
        case .forest:
            health = 50
            maxHealth = 50
            damage = 15
            speed = 60.0
            movementPattern = .chase
            
        case .boss:
            health = 200
            maxHealth = 200
            damage = 30
            speed = 30.0
            movementPattern = .stationary
            
        case .rakshasa:
            health = 80
            maxHealth = 80
            damage = 25
            speed = 45.0
            movementPattern = .circle
            
        case .golden:
            health = 100
            maxHealth = 100
            damage = 20
            speed = 70.0
            movementPattern = .chase
        }
    }
    
    private func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.categoryBitMask = enemyCategory
        physicsBody?.contactTestBitMask = 0x1 << 0 | 0x1 << 3 // Player and Projectile categories
        physicsBody?.collisionBitMask = 0
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
    }
    
    private func setupAnimations() {
        // Add enemy-specific animations
        switch type {
        case .basic:
            addBasicAnimation()
        case .forest:
            addForestAnimation()
        case .boss:
            addBossAnimation()
        case .rakshasa:
            addRakshasaAnimation()
        case .golden:
            addGoldenAnimation()
        }
    }
    
    private func addBasicAnimation() {
        // Simple pulsing animation
        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        run(SKAction.repeatForever(pulse))
    }
    
    private func addForestAnimation() {
        // Spinning animation
        let spin = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 3.0)
        run(SKAction.repeatForever(spin))
    }
    
    private func addBossAnimation() {
        // Large pulsing with color change
        let pulse = SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 1.2, duration: 1.0),
                SKAction.colorize(with: .systemOrange, colorBlendFactor: 1.0, duration: 1.0)
            ]),
            SKAction.group([
                SKAction.scale(to: 1.0, duration: 1.0),
                SKAction.colorize(with: .systemPurple, colorBlendFactor: 1.0, duration: 1.0)
            ])
        ])
        run(SKAction.repeatForever(pulse))
    }
    
    private func addRakshasaAnimation() {
        // Aggressive shaking
        let shake = SKAction.sequence([
            SKAction.moveBy(x: 2, y: 0, duration: 0.1),
            SKAction.moveBy(x: -4, y: 0, duration: 0.1),
            SKAction.moveBy(x: 2, y: 0, duration: 0.1)
        ])
        run(SKAction.repeatForever(shake))
    }
    
    private func addGoldenAnimation() {
        // Golden sparkle effect
        let sparkle = SKEmitterNode()
        sparkle.particleBirthRate = 3
        sparkle.particleLifetime = 1.0
        sparkle.particleSpeed = 20
        sparkle.particleSpeedRange = 10
        sparkle.particleAlpha = 0.6
        sparkle.particleAlphaRange = 0.3
        sparkle.particleScale = 0.1
        sparkle.particleScaleRange = 0.05
        sparkle.particleColor = .systemYellow
        sparkle.position = CGPoint(x: 0, y: 0)
        sparkle.zPosition = -1
        addChild(sparkle)
    }
    
    func takeDamage(_ damage: Int) {
        health = max(0, health - damage)
        
        // Visual feedback
        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        run(flash)
        
        if health <= 0 {
            die()
        }
        
        // Play damage sound
        AudioManager.shared.playSound(.enemyHit)
    }
    
    private func die() {
        isAlive = false
        
        // Death animation
        let deathAnimation = SKAction.group([
            SKAction.scale(to: 0, duration: 0.5),
            SKAction.fadeOut(withDuration: 0.5)
        ])
        
        run(deathAnimation) {
            self.removeFromParent()
        }
        
        // Play death sound
        AudioManager.shared.playSound(.enemyDeath)
    }
    
    func update(_ currentTime: TimeInterval) {
        if !isAlive { return }
        
        // Update movement based on pattern
        switch movementPattern {
        case .patrol:
            updatePatrolMovement()
        case .chase:
            updateChaseMovement()
        case .circle:
            updateCircleMovement()
        case .stationary:
            updateStationaryBehavior()
        }
        
        // Update attack cooldown
        if currentTime - lastAttackTime >= attackCooldown {
            performAttack()
            lastAttackTime = currentTime
        }
    }
    
    private func updatePatrolMovement() {
        // Simple back and forth movement
        let moveLeft = SKAction.moveBy(x: -50, y: 0, duration: 2.0)
        let moveRight = SKAction.moveBy(x: 50, y: 0, duration: 2.0)
        let patrolSequence = SKAction.sequence([moveLeft, moveRight])
        
        if action(forKey: "patrol") == nil {
            run(patrolSequence, withKey: "patrol")
        }
    }
    
    private func updateChaseMovement() {
        // Move towards player if nearby
        // This would require access to player position from the game scene
        // For now, just move downward
        let moveDown = SKAction.moveBy(x: 0, y: -speed, duration: 1.0)
        run(moveDown)
    }
    
    private func updateCircleMovement() {
        // Circular movement pattern
        let radius: CGFloat = 50
        let circleAction = SKAction.sequence([
            SKAction.moveBy(x: radius, y: 0, duration: 1.0),
            SKAction.moveBy(x: 0, y: radius, duration: 1.0),
            SKAction.moveBy(x: -radius, y: 0, duration: 1.0),
            SKAction.moveBy(x: 0, y: -radius, duration: 1.0)
        ])
        
        if action(forKey: "circle") == nil {
            run(circleAction, withKey: "circle")
        }
    }
    
    private func updateStationaryBehavior() {
        // Boss enemies stay in place but can attack
        // They might have special attacks
    }
    
    private func performAttack() {
        // Create enemy projectile
        let projectile = SKSpriteNode(color: .systemRed, size: CGSize(width: 6, height: 6))
        projectile.position = position
        projectile.zPosition = 4
        
        // Physics body for enemy projectile
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        projectile.physicsBody?.categoryBitMask = 0x1 << 5 // Enemy projectile category
        projectile.physicsBody?.contactTestBitMask = 0x1 << 0 // Player category
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.isDynamic = true
        
        scene?.addChild(projectile)
        
        // Move projectile toward player (or downward for now)
        let moveAction = SKAction.moveBy(x: 0, y: -200, duration: 2.0)
        let removeAction = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([moveAction, removeAction]))
        
        // Play attack sound
        AudioManager.shared.playSound(.enemyAttack)
    }
    
    func getHealthPercentage() -> CGFloat {
        return CGFloat(health) / CGFloat(maxHealth)
    }
}
