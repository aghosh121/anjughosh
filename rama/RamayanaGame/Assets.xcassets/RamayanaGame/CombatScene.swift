import SpriteKit
import UIKit

class CombatScene: SKScene {
    
    private var ramaNode: SKSpriteNode!
    private var demonNode: SKSpriteNode!
    private var backgroundNode: SKSpriteNode!
    private var healthLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var ramaHealth = 100
    private var demonHealth = 100
    private var score = 0
    private var isCombatActive = false
    
    override func didMove(to view: SKView) {
        setupScene()
        setupUI()
        createParticleEffects()
        startCombat()
    }
    
    private func setupScene() {
        // Create forest background
        backgroundNode = SKSpriteNode(imageNamed: "Background")
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Create Lord Rama sprite
        ramaNode = SKSpriteNode(imageNamed: "Rama")
        ramaNode.position = CGPoint(x: size.width * 0.3, y: size.height * 0.4)
        ramaNode.zPosition = 10
        addChild(ramaNode)
        
        // Create demon sprite
        demonNode = SKSpriteNode(imageNamed: "Demon")
        demonNode.position = CGPoint(x: size.width * 0.7, y: size.height * 0.4)
        demonNode.zPosition = 10
        addChild(demonNode)
        
        print("CombatScene: Sprites loaded successfully")
    }
    
    private func setupUI() {
        // Health display
        healthLabel = SKLabelNode(text: "Rama Health: \(ramaHealth)")
        healthLabel.position = CGPoint(x: size.width * 0.2, y: size.height * 0.9)
        healthLabel.fontSize = 18
        healthLabel.fontColor = .white
        healthLabel.zPosition = 20
        addChild(healthLabel)
        
        // Score display
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
        scoreLabel.fontSize = 18
        scoreLabel.fontColor = .white
        scoreLabel.zPosition = 20
        addChild(scoreLabel)
        
        // Instructions
        let instructionLabel = SKLabelNode(text: "Tap to attack!")
        instructionLabel.position = CGPoint(x: size.width/2, y: size.height * 0.1)
        instructionLabel.fontSize = 16
        instructionLabel.fontColor = .yellow
        instructionLabel.zPosition = 20
        addChild(instructionLabel)
    }
    
    private func createParticleEffects() {
        // Create magical particle effect
        let particleTexture = createParticleTexture()
        let particleEmitter = SKEmitterNode()
        particleEmitter.particleTexture = particleTexture
        particleEmitter.particleBirthRate = 50
        particleEmitter.particleLifetime = 2.0
        particleEmitter.particleSpeed = 50
        particleEmitter.particleSpeedRange = 20
        particleEmitter.particleAlpha = 0.8
        particleEmitter.particleAlphaRange = 0.2
        particleEmitter.particleScale = 0.5
        particleEmitter.particleScaleRange = 0.3
        particleEmitter.particleColor = .cyan
        particleEmitter.particleColorBlendFactor = 1.0
        particleEmitter.position = CGPoint(x: size.width/2, y: size.height * 0.2)
        particleEmitter.zPosition = 5
        addChild(particleEmitter)
    }
    
    private func createParticleTexture() -> SKTexture {
        let size = CGSize(width: 4, height: 4)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(ovalIn: rect)
            UIColor.white.setFill()
            path.fill()
        }
        return SKTexture(image: image)
    }
    
    private func startCombat() {
        isCombatActive = true
        animateRama()
        animateDemon()
    }
    
    private func animateRama() {
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.5)
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.5)
        let sequence = SKAction.sequence([moveUp, moveDown])
        ramaNode.run(SKAction.repeatForever(sequence))
    }
    
    private func animateDemon() {
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.7)
        let moveDown = SKAction.moveBy(x: 0, y: -10, duration: 0.7)
        let sequence = SKAction.sequence([moveDown, moveUp])
        demonNode.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Check if touch is on Rama's side (left side of screen)
        if location.x < size.width/2 {
            performDirectAttack()
        } else {
            performSpecialAttack()
        }
    }
    
    private func performDirectAttack() {
        guard isCombatActive else { return }
        
        // Rama attacks demon
        demonHealth -= 15
        score += 10
        
        // Visual feedback
        demonNode.run(SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
        
        // Create attack effect
        let attackEffect = SKSpriteNode(color: .yellow, size: CGSize(width: 20, height: 20))
        attackEffect.position = demonNode.position
        attackEffect.zPosition = 15
        addChild(attackEffect)
        
        attackEffect.run(SKAction.sequence([
            SKAction.scale(to: 2.0, duration: 0.2),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.removeFromParent()
        ]))
        
        updateHealthDisplay()
        
        // Demon counter-attack
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.demonAttack()
        }
    }
    
    private func performSpecialAttack() {
        guard isCombatActive else { return }
        
        // Special arrow attack
        createSpecialArrow()
        
        demonHealth -= 25
        score += 20
        
        updateHealthDisplay()
        
        // Demon counter-attack
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.demonAttack()
        }
    }
    
    private func createSpecialArrow() {
        let arrow = SKSpriteNode(color: .orange, size: CGSize(width: 30, height: 5))
        arrow.position = ramaNode.position
        arrow.zPosition = 12
        addChild(arrow)
        
        let moveAction = SKAction.moveTo(x: demonNode.position.x, duration: 0.5)
        let fadeAction = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        
        arrow.run(SKAction.sequence([
            SKAction.group([moveAction, fadeAction]),
            removeAction
        ]))
    }
    
    private func demonAttack() {
        guard isCombatActive else { return }
        
        // Demon attacks Rama
        ramaHealth -= 10
        
        // Visual feedback
        ramaNode.run(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
        
        updateHealthDisplay()
        
        // Check for game over
        if ramaHealth <= 0 {
            gameOver(victory: false)
        } else if demonHealth <= 0 {
            gameOver(victory: true)
        }
    }
    
    private func updateHealthDisplay() {
        healthLabel.text = "Rama Health: \(ramaHealth)"
        scoreLabel.text = "Score: \(score)"
    }
    
    private func gameOver(victory: Bool) {
        isCombatActive = false
        
        let gameOverScene = GameOverScene(size: size)
        gameOverScene.victory = victory
        gameOverScene.finalScore = score
        
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(gameOverScene, transition: transition)
    }
}
