import SpriteKit
import AppKit

class CombatScene: SKScene {
    
    private var ramaNode: Player!
    private var demonNode: SKSpriteNode!
    private var backgroundNode: SKSpriteNode!
    private var healthBarNode: SKSpriteNode!
    private var healthLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var titleLabel: SKLabelNode!
    
    private var ramaHealth = 100
    private var demonHealth = 100
    private var score = 0
    
    override func didMove(to view: SKView) {
        setupScene()
        setupUI()
        startCombat()
        
        // Enable keyboard input for macOS
        print("Setting up keyboard input...")
        view.window?.makeFirstResponder(self)
        
        // Additional keyboard setup
        DispatchQueue.main.async {
            self.view?.window?.makeFirstResponder(self)
            print("Keyboard focus set to scene")
            
            // Force keyboard focus
            self.view?.window?.makeFirstResponder(self)
            print("Forced keyboard focus to scene")
        }
    }
    
    // Override to ensure scene can receive keyboard events
    override func sceneDidLoad() {
        super.sceneDidLoad()
        print("Scene loaded - ready for keyboard input")
    }
    
    // Ensure scene can receive keyboard input when it becomes active
    override func didBecomeActive() {
        super.didBecomeActive()
        print("Scene became active - setting keyboard focus")
        view?.window?.makeFirstResponder(self)
    }
    

    

    
    // Force keyboard input to work - try this method
    override func keyDown(with event: NSEvent) {
        print("=== FORCED KEYBOARD METHOD ===")
        let keyCode = event.keyCode
        print("FORCED - Key pressed: \(keyCode)")
        
        // ANY key should move Rama
        if keyCode == 123 { // Left
            print("LEFT ARROW - Moving left")
            moveRama(direction: .left)
        } else if keyCode == 124 { // Right
            print("RIGHT ARROW - Moving right")
            moveRama(direction: .right)
        } else if keyCode == 125 { // Down
            print("DOWN ARROW - Moving down")
            moveRama(direction: .down)
        } else if keyCode == 126 { // Up
            print("UP ARROW - Moving up")
            moveRama(direction: .up)
        } else if keyCode == 49 { // Spacebar
            print("SPACEBAR - Shooting")
            createSpecialArrow()
        } else {
            print("OTHER KEY - Testing movement")
            moveRama(direction: .right)
        }
    }
    

    
    // Test if scene is receiving any events at all
    override func mouseDown(with event: NSEvent) {
        print("=== MOUSE EVENT DETECTED ===")
        print("Mouse clicked at: \(event.location(in: self))")
        
        // Test movement with mouse click
        print("Testing movement with mouse click...")
        moveRama(direction: .up)
        
        // Now handle the original mouse logic
        let location = event.location(in: self)
        
        // Check if click is on Rama (special attack)
        if ramaNode.contains(location) {
            performSpecialAttack()
        }
        
        // Check if click is on demon (direct attack)
        if demonNode.contains(location) {
            performDirectAttack()
        }
    }
    
    private func setupScene() {
        // Create forest background
        backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Create Lord Rama sprite using Player class for animations
        print("About to create Player instance...")
        
        // Test if Player class exists
        if let playerClass = NSClassFromString("RamayanaGame.Player") {
            print("✅ Player class found: \(playerClass)")
            ramaNode = Player()
            print("✅ Player instance created successfully")
        } else {
            print("❌ Player class not found, using fallback SKSpriteNode")
            ramaNode = SKSpriteNode(imageNamed: "rama")
        }
        
        ramaNode.position = CGPoint(x: size.width * 0.3, y: size.height * 0.4)
        ramaNode.zPosition = 10
        ramaNode.setScale(0.8)
        addChild(ramaNode)
        
        print("✅ Rama node created and added to scene")
        
        // Test if animation is working
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("Testing animation after 1 second...")
            if let player = self.ramaNode as? Player {
                print("Player type confirmed, testing animation...")
                // Force a test animation
                let testMove = SKAction.moveBy(x: 10, y: 0, duration: 0.5)
                player.run(testMove)
                print("Test animation applied")
            } else {
                print("❌ ramaNode is not a Player type!")
                print("ramaNode type: \(type(of: self.ramaNode))")
            }
        }
        
        // Create demon sprite
        demonNode = SKSpriteNode(imageNamed: "demon")
        demonNode.position = CGPoint(x: size.width * 0.7, y: size.height * 0.4)
        demonNode.zPosition = 10
        demonNode.setScale(0.8)
        addChild(demonNode)
        
        // Add particle effects
        createParticleEffects()
    }
    
    private func setupUI() {
        // Game title
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "RAMA THE LEGEND"
        titleLabel.fontSize = 32
        titleLabel.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Golden
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.9)
        titleLabel.zPosition = 20
        addChild(titleLabel)
        
        // Health bar
        let healthBarWidth: CGFloat = 200
        let healthBarHeight: CGFloat = 20
        
        healthBarNode = SKSpriteNode(color: SKColor.red, size: CGSize(width: healthBarWidth, height: healthBarHeight))
        healthBarNode.position = CGPoint(x: size.width * 0.15, y: size.height * 0.85)
        healthBarNode.zPosition = 20
        addChild(healthBarNode)
        
        // Health label
        healthLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        healthLabel.text = "19"
        healthLabel.fontSize = 18
        healthLabel.fontColor = SKColor.white
        healthLabel.position = CGPoint(x: size.width * 0.15 + healthBarWidth/2 + 30, y: size.height * 0.85)
        healthLabel.zPosition = 20
        addChild(healthLabel)
        
        // Score label (coin counter)
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        scoreLabel.text = "x 35"
        scoreLabel.fontSize = 18
        scoreLabel.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Golden
        scoreLabel.position = CGPoint(x: size.width * 0.85, y: size.height * 0.85)
        scoreLabel.zPosition = 20
        addChild(scoreLabel)
    }
    
    private func createParticleEffects() {
        // Mystical particles around Rama
        let ramaParticles = SKEmitterNode()
        ramaParticles.particleTexture = createParticleTexture()
        ramaParticles.particleBirthRate = 15
        ramaParticles.particleLifetime = 3.0
        ramaParticles.particleSpeed = 30
        ramaParticles.particleSpeedRange = 10
        ramaParticles.particleAlpha = 0.7
        ramaParticles.particleAlphaRange = 0.3
        ramaParticles.particleScale = 0.3
        ramaParticles.particleScaleRange = 0.2
        ramaParticles.particleColor = SKColor(red: 0.53, green: 0.81, blue: 0.92, alpha: 1.0) // Blue like Rama
        ramaParticles.position = ramaNode.position
        ramaParticles.particlePositionRange = CGVector(dx: 60, dy: 60)
        addChild(ramaParticles)
        
        // Dark particles around demon
        let demonParticles = SKEmitterNode()
        demonParticles.particleTexture = createParticleTexture()
        demonParticles.particleBirthRate = 20
        demonParticles.particleLifetime = 2.0
        demonParticles.particleSpeed = 40
        demonParticles.particleSpeedRange = 15
        demonParticles.particleAlpha = 0.8
        demonParticles.particleAlphaRange = 0.4
        demonParticles.particleScale = 0.4
        demonParticles.particleScaleRange = 0.3
        demonParticles.particleColor = SKColor(red: 0.86, green: 0.08, blue: 0.24, alpha: 1.0) // Red like demon
        demonParticles.position = demonNode.position
        demonParticles.particlePositionRange = CGVector(dx: 80, dy: 80)
        addChild(demonParticles)
    }
    
    private func createParticleTexture() -> SKTexture {
        let size = CGSize(width: 4, height: 4)
        let texture = SKTexture(size: size) { context in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(ovalIn: rect)
            UIColor.white.setFill()
            path.fill()
        }
        return texture
    }
    
    private func startCombat() {
        // Animate characters
        animateRama()
        animateDemon()
        
        // Start combat sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performCombatSequence()
        }
    }
    
    private func animateRama() {
        // Rama's bow-drawing animation
        let bowAction = SKAction.sequence([
            SKAction.scale(to: 0.9, duration: 0.3),
            SKAction.scale(to: 1.0, duration: 0.3)
        ])
        ramaNode.run(SKAction.repeatForever(bowAction))
        
        // Floating animation
        let floatAction = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 10, duration: 1.0),
            SKAction.moveBy(x: 0, y: -10, duration: 1.0)
        ])
        ramaNode.run(SKAction.repeatForever(floatAction))
    }
    
    private func animateDemon() {
        // Demon's aggressive animation
        let demonAction = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.4),
            SKAction.scale(to: 0.9, duration: 0.4)
        ])
        demonNode.run(SKAction.repeatForever(demonAction))
        
        // Shaking animation
        let shakeAction = SKAction.sequence([
            SKAction.moveBy(x: 5, y: 0, duration: 0.1),
            SKAction.moveBy(x: -10, y: 0, duration: 0.1),
            SKAction.moveBy(x: 5, y: 0, duration: 0.1)
        ])
        demonNode.run(SKAction.repeatForever(shakeAction))
    }
    
    private func performCombatSequence() {
        // Rama attacks
        ramaAttack()
        
        // Demon counter-attacks
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.demonAttack()
        }
        
        // Continue combat
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.performCombatSequence()
        }
    }
    
    private func ramaAttack() {
        // Create arrow projectile
        let arrow = SKSpriteNode(color: SKColor(red: 0.55, green: 0.27, blue: 0.07, alpha: 1.0), size: CGSize(width: 20, height: 4))
        arrow.position = ramaNode.position
        arrow.zPosition = 15
        addChild(arrow)
        
        // Arrow flight animation
        let arrowAction = SKAction.sequence([
            SKAction.moveTo(x: demonNode.position.x, duration: 0.5),
            SKAction.removeFromParent()
        ])
        arrow.run(arrowAction)
        
        // Damage demon
        demonHealth -= 15
        updateHealthDisplay()
        
        // Visual feedback
        demonNode.run(SKAction.sequence([
            SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.1),
            SKAction.colorize(with: SKColor.white, colorBlendFactor: 0.0, duration: 0.1)
        ]))
        
        // Update score
        score += 10
        scoreLabel.text = "x \(score)"
    }
    
    private func demonAttack() {
        // Create demon projectile
        let demonProjectile = SKSpriteNode(color: SKColor(red: 0.86, green: 0.08, blue: 0.24, alpha: 1.0), size: CGSize(width: 15, height: 15))
        demonProjectile.position = demonNode.position
        demonProjectile.zPosition = 15
        addChild(demonProjectile)
        
        // Projectile flight animation
        let projectileAction = SKAction.sequence([
            SKAction.moveTo(x: ramaNode.position.x, duration: 0.6),
            SKAction.removeFromParent()
        ])
        demonProjectile.run(projectileAction)
        
        // Damage Rama
        ramaHealth -= 10
        updateHealthDisplay()
        
        // Visual feedback
        ramaNode.run(SKAction.sequence([
            SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.1),
            SKAction.colorize(with: SKColor.white, colorBlendFactor: 0.0, duration: 0.1)
        ]))
    }
    
    private func updateHealthDisplay() {
        let healthPercentage = CGFloat(ramaHealth) / 100.0
        let healthBarWidth: CGFloat = 200
        
        healthBarNode.size.width = healthBarWidth * healthPercentage
        healthLabel.text = "\(ramaHealth)"
        
        // Change health bar color based on health
        if ramaHealth > 60 {
            healthBarNode.color = SKColor.green
        } else if ramaHealth > 30 {
            healthBarNode.color = SKColor.orange
        } else {
            healthBarNode.color = SKColor.red
        }
    }
    
    // MOUSE CONTROLS - Only for special attacks, NOT for movement
    // Use ARROW KEYS to move Rama around the screen
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        
        // Check if click is on Rama (special attack)
        if ramaNode.contains(location) {
            performSpecialAttack()
        }
        
        // Check if click is on demon (direct attack)
        if demonNode.contains(location) {
            performDirectAttack()
        }
    }
    
    private func performSpecialAttack() {
        // Rama's special attack animation
        ramaNode.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.2),
            SKAction.scale(to: 0.8, duration: 0.2),
            SKAction.scale(to: 1.0, duration: 0.2)
        ]))
        
        // Multiple arrows
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                self.createSpecialArrow()
            }
        }
        
        // Heavy damage
        demonHealth -= 30
        score += 25
        scoreLabel.text = "x \(score)"
    }
    
    private func performDirectAttack() {
        // Direct attack animation
        demonNode.run(SKAction.sequence([
            SKAction.scale(to: 0.7, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
        
        // Damage demon
        demonHealth -= 20
        score += 15
        scoreLabel.text = "x \(score)"
        
        // Visual feedback
        demonNode.run(SKAction.sequence([
            SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.1),
            SKAction.colorize(with: SKColor.white, colorBlendFactor: 0.0, duration: 0.1)
        ]))
    }
    
    private func createSpecialArrow() {
        let arrow = SKSpriteNode(color: SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0), size: CGSize(width: 25, height: 6))
        arrow.position = ramaNode.position
        arrow.zPosition = 15
        addChild(arrow)
        
        // Golden arrow with special trajectory
        let arrowAction = SKAction.sequence([
            SKAction.moveTo(x: demonNode.position.x, duration: 0.3),
            SKAction.removeFromParent()
        ])
        arrow.run(arrowAction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Check for game over conditions
        if ramaHealth <= 0 {
            gameOver(won: false)
        } else if demonHealth <= 0 {
            gameOver(won: true)
        }
    }
    

    
    private enum MoveDirection {
        case left, right, up, down
    }
    
    private func moveRama(direction: MoveDirection) {
        let moveDistance: CGFloat = 30
        var newPosition = ramaNode.position
        
        switch direction {
        case .left:
            newPosition.x -= moveDistance
        case .right:
            newPosition.x += moveDistance
        case .up:
            newPosition.y += moveDistance
        case .down:
            newPosition.y -= moveDistance
        }
        
        // Keep Rama within screen bounds
        newPosition.x = max(50, min(size.width - 50, newPosition.x))
        newPosition.y = max(50, min(size.height - 50, newPosition.y))
        
        let moveAction = SKAction.move(to: newPosition, duration: 0.2)
        moveAction.timingMode = .easeOut
        ramaNode.run(moveAction)
        
        // Flip Rama sprite based on direction
        ramaNode.flipSprite(direction: direction)
        
        // Move background in opposite direction for parallax effect
        moveBackground(direction: direction)
    }
    
    private func moveBackground(direction: MoveDirection) {
        let moveDistance: CGFloat = 15
        var newBackgroundPosition = backgroundNode.position
        
        switch direction {
        case .left:
            newBackgroundPosition.x += moveDistance
        case .right:
            newBackgroundPosition.x -= moveDistance
        case .up:
            newBackgroundPosition.y -= moveDistance
        case .down:
            newBackgroundPosition.y += moveDistance
        }
        
        let moveAction = SKAction.move(to: newBackgroundPosition, duration: 0.2)
        moveAction.timingMode = .easeOut
        backgroundNode.run(moveAction)
    }
    
    // MARK: - macOS Keyboard Support
    
    override var acceptsFirstResponder: Bool {
        print("Scene accepts first responder")
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        print("Scene became first responder")
        return true
    }
    

    
    // Additional keyboard support methods
    override func keyUp(with event: NSEvent) {
        print("Key released: \(event.keyCode)")
    }
    
    override func flagsChanged(with event: NSEvent) {
        print("Modifier keys changed")
    }
    
    private func gameOver(won: Bool) {
        // Stop all animations
        ramaNode.removeAllActions()
        demonNode.removeAllActions()
        
        // Create game over scene
        let gameOverScene = GameOverScene(size: size)
        gameOverScene.scaleMode = .aspectFill
        gameOverScene.won = won
        gameOverScene.finalScore = score
        
        // Transition with fade
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(gameOverScene, transition: transition)
    }
}

class GameOverScene: SKScene {
    var won: Bool = false
    var finalScore: Int = 0
    
    override func didMove(to view: SKView) {
        setupGameOverScene()
    }
    
    private func setupGameOverScene() {
        // Background
        backgroundColor = won ? SKColor(red: 0.1, green: 0.3, blue: 0.1, alpha: 1.0) : SKColor(red: 0.3, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Title
        let titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = won ? "VICTORY!" : "DEFEAT"
        titleLabel.fontSize = 48
        titleLabel.fontColor = won ? SKColor.green : SKColor.red
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        addChild(titleLabel)
        
        // Score
        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        scoreLabel.text = "Final Score: \(finalScore)"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.5)
        addChild(scoreLabel)
        
        // Restart button
        let restartButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
        restartButton.text = "Tap to Restart"
        restartButton.fontSize = 28
        restartButton.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        restartButton.position = CGPoint(x: size.width/2, y: size.height * 0.3)
        restartButton.name = "restart"
        addChild(restartButton)
        
        // Pulse animation
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 1.0),
            SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        ])
        restartButton.run(SKAction.repeatForever(pulseAction))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "restart" {
            // Restart the combat scene
            let combatScene = CombatScene(size: size)
            combatScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(combatScene, transition: transition)
        }
    }
}
