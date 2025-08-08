import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: Player!
    private var enemies: [Enemy] = []
    private var powerUps: [PowerUp] = []
    private var backgroundNode: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var healthLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var pauseButton: SKSpriteNode!
    
    private var currentLevel: Int = 1
    private var score: Int = 0
    private var gamePaused: Bool = false
    
    // Physics categories
    let playerCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    let powerUpCategory: UInt32 = 0x1 << 2
    let projectileCategory: UInt32 = 0x1 << 3
    let boundaryCategory: UInt32 = 0x1 << 4
    
    init(size: CGSize, level: Int) {
        self.currentLevel = level
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        setupPhysics()
        setupBackground()
        setupUI()
        setupPlayer()
        setupLevel()
        setupControls()
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    private func setupBackground() {
        // Create level-specific background
        let backgroundColors: [UIColor] = [
            .systemBlue,    // Level 1 - Palace
            .systemGreen,   // Level 2 - Forest
            .systemYellow,  // Level 3 - Golden Deer
            .systemPurple,  // Level 4 - Lanka
            .systemOrange,  // Level 5 - Bridge
            .systemRed      // Level 6 - Battle
        ]
        
        let backgroundColor = backgroundColors[min(currentLevel - 1, backgroundColors.count - 1)]
        backgroundNode = SKSpriteNode(color: backgroundColor, size: size)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Add particle effects based on level
        addLevelSpecificEffects()
    }
    
    private func addLevelSpecificEffects() {
        switch currentLevel {
        case 1:
            // Palace - golden particles
            addParticleEffect(color: .yellow, position: CGPoint(x: size.width/2, y: size.height))
        case 2:
            // Forest - green leaves
            addParticleEffect(color: .green, position: CGPoint(x: size.width/2, y: size.height))
        case 3:
            // Golden deer - sparkles
            addParticleEffect(color: .orange, position: CGPoint(x: size.width/2, y: size.height))
        default:
            break
        }
    }
    
    private func addParticleEffect(color: UIColor, position: CGPoint) {
        let emitter = SKEmitterNode()
        emitter.particleTexture = SKTexture(imageNamed: "spark")
        emitter.position = position
        emitter.particleBirthRate = 10
        emitter.particleLifetime = 4.0
        emitter.particleSpeed = 50
        emitter.particleSpeedRange = 20
        emitter.emissionAngle = CGFloat.pi
        emitter.emissionAngleRange = CGFloat.pi / 4
        emitter.particleAlpha = 0.8
        emitter.particleAlphaRange = 0.2
        emitter.particleScale = 0.1
        emitter.particleScaleRange = 0.05
        emitter.particleColor = color
        emitter.zPosition = -5
        addChild(emitter)
    }
    
    private func setupUI() {
        // Score Label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 100, y: size.height - 50)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        // Health Label
        healthLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        healthLabel.text = "Health: 100"
        healthLabel.fontSize = 20
        healthLabel.fontColor = .green
        healthLabel.position = CGPoint(x: 100, y: size.height - 80)
        healthLabel.zPosition = 10
        addChild(healthLabel)
        
        // Level Label
        levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        levelLabel.text = "Level \(currentLevel)"
        levelLabel.fontSize = 24
        levelLabel.fontColor = .white
        levelLabel.position = CGPoint(x: size.width/2, y: size.height - 50)
        levelLabel.zPosition = 10
        addChild(levelLabel)
        
        // Pause Button
        pauseButton = SKSpriteNode(color: .systemGray, size: CGSize(width: 60, height: 40))
        pauseButton.position = CGPoint(x: size.width - 50, y: size.height - 50)
        pauseButton.name = "pause_button"
        pauseButton.zPosition = 10
        
        let pauseLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        pauseLabel.text = "⏸"
        pauseLabel.fontSize = 20
        pauseLabel.fontColor = .white
        pauseLabel.verticalAlignmentMode = .center
        pauseButton.addChild(pauseLabel)
        
        addChild(pauseButton)
    }
    
    private func setupPlayer() {
        player = Player()
        player.position = CGPoint(x: size.width/2, y: 100)
        player.zPosition = 5
        addChild(player)
    }
    
    private func setupLevel() {
        switch currentLevel {
        case 1:
            setupLevel1()
        case 2:
            setupLevel2()
        case 3:
            setupLevel3()
        default:
            setupDefaultLevel()
        }
    }
    
    private func setupLevel1() {
        // Level 1: The Birth of Rama - Simple enemies
        spawnEnemies(count: 5, type: .basic)
        spawnPowerUps(count: 2)
    }
    
    private func setupLevel2() {
        // Level 2: Forest Exile - More challenging enemies
        spawnEnemies(count: 8, type: .forest)
        spawnPowerUps(count: 3)
    }
    
    private func setupLevel3() {
        // Level 3: Golden Deer - Boss level
        spawnEnemies(count: 3, type: .boss)
        spawnPowerUps(count: 1)
    }
    
    private func setupDefaultLevel() {
        spawnEnemies(count: 6, type: .basic)
        spawnPowerUps(count: 2)
    }
    
    private func spawnEnemies(count: Int, type: EnemyType) {
        for _ in 0..<count {
            let enemy = Enemy(type: type)
            let randomX = CGFloat.random(in: 50...(size.width - 50))
            let randomY = CGFloat.random(in: (size.height * 0.6)...(size.height - 100))
            enemy.position = CGPoint(x: randomX, y: randomY)
            enemy.zPosition = 3
            enemies.append(enemy)
            addChild(enemy)
        }
    }
    
    private func spawnPowerUps(count: Int) {
        for _ in 0..<count {
            let powerUp = PowerUp()
            let randomX = CGFloat.random(in: 50...(size.width - 50))
            let randomY = CGFloat.random(in: 100...(size.height * 0.5))
            powerUp.position = CGPoint(x: randomX, y: randomY)
            powerUp.zPosition = 4
            powerUps.append(powerUp)
            addChild(powerUp)
        }
    }
    
    private func setupControls() {
        // Touch controls will be handled in touchesBegan
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "pause_button" {
            togglePause()
            return
        }
        
        // Move player to touch location
        if !gamePaused {
            movePlayer(to: location)
        }
    }
    
    private func movePlayer(to location: CGPoint) {
        let moveAction = SKAction.move(to: location, duration: 0.5)
        moveAction.timingMode = .easeOut
        player.run(moveAction)
        
        // Player shoots automatically when moving
        shootProjectile()
    }
    
    private func shootProjectile() {
        let projectile = SKSpriteNode(color: .yellow, size: CGSize(width: 8, height: 8))
        projectile.position = player.position
        projectile.zPosition = 4
        
        // Physics body for projectile
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        projectile.physicsBody?.categoryBitMask = projectileCategory
        projectile.physicsBody?.contactTestBitMask = enemyCategory
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.isDynamic = true
        
        addChild(projectile)
        
        // Move projectile upward
        let moveAction = SKAction.moveBy(x: 0, y: size.height, duration: 1.0)
        let removeAction = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    private func togglePause() {
        gamePaused.toggle()
        if gamePaused {
            scene?.view?.isPaused = true
            pauseButton.children.first?.text = "▶"
        } else {
            scene?.view?.isPaused = false
            pauseButton.children.first?.text = "⏸"
        }
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == playerCategory | enemyCategory {
            handlePlayerEnemyCollision(contact)
        } else if collision == projectileCategory | enemyCategory {
            handleProjectileEnemyCollision(contact)
        } else if collision == playerCategory | powerUpCategory {
            handlePlayerPowerUpCollision(contact)
        }
    }
    
    private func handlePlayerEnemyCollision(_ contact: SKPhysicsContact) {
        // Player takes damage
        player.takeDamage(20)
        updateHealthLabel()
        
        // Remove enemy
        let enemy = contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node : contact.bodyB.node
        enemy?.removeFromParent()
        
        if let enemyIndex = enemies.firstIndex(where: { $0 == enemy as? Enemy }) {
            enemies.remove(at: enemyIndex)
        }
        
        // Check if player is defeated
        if player.health <= 0 {
            gameOver()
        }
    }
    
    private func handleProjectileEnemyCollision(_ contact: SKPhysicsContact) {
        // Enemy takes damage
        let enemy = contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node : contact.bodyB.node
        let projectile = contact.bodyA.categoryBitMask == projectileCategory ? contact.bodyA.node : contact.bodyB.node
        
        if let enemy = enemy as? Enemy {
            enemy.takeDamage(25)
            
            if enemy.health <= 0 {
                // Enemy defeated
                score += 100
                updateScoreLabel()
                enemy.removeFromParent()
                
                if let enemyIndex = enemies.firstIndex(of: enemy) {
                    enemies.remove(at: enemyIndex)
                }
                
                // Check if level is complete
                if enemies.isEmpty {
                    levelComplete()
                }
            }
        }
        
        projectile?.removeFromParent()
    }
    
    private func handlePlayerPowerUpCollision(_ contact: SKPhysicsContact) {
        let powerUp = contact.bodyA.categoryBitMask == powerUpCategory ? contact.bodyA.node : contact.bodyB.node
        
        if let powerUp = powerUp as? PowerUp {
            player.applyPowerUp(powerUp.type)
            powerUp.removeFromParent()
            
            if let powerUpIndex = powerUps.firstIndex(of: powerUp) {
                powerUps.remove(at: powerUpIndex)
            }
            
            updateHealthLabel()
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    private func updateHealthLabel() {
        healthLabel.text = "Health: \(player.health)"
        healthLabel.fontColor = player.health > 50 ? .green : (player.health > 25 ? .yellow : .red)
    }
    
    private func levelComplete() {
        let levelCompleteScene = GameOverScene(size: size, won: true, score: score, level: currentLevel)
        levelCompleteScene.scaleMode = .aspectFill
        view?.presentScene(levelCompleteScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    private func gameOver() {
        let gameOverScene = GameOverScene(size: size, won: false, score: score, level: currentLevel)
        gameOverScene.scaleMode = .aspectFill
        view?.presentScene(gameOverScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !gamePaused {
            // Update enemies
            for enemy in enemies {
                enemy.update(currentTime)
            }
            
            // Update player
            player.update(currentTime)
        }
    }
}
