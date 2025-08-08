import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var scoreLabel: SKLabelNode!
    private var levelLabel: SKLabelNode!
    private var messageLabel: SKLabelNode!
    private var retryButton: SKSpriteNode!
    private var mainMenuButton: SKSpriteNode!
    private var nextLevelButton: SKSpriteNode!
    
    private let won: Bool
    private let score: Int
    private let level: Int
    
    init(size: CGSize, won: Bool, score: Int, level: Int) {
        self.won = won
        self.score = score
        self.level = level
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.won = false
        self.score = 0
        self.level = 1
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupScore()
        setupMessage()
        setupButtons()
        setupParticleEffects()
    }
    
    private func setupBackground() {
        // Create victory or defeat themed background
        let backgroundColor = won ? UIColor.systemGreen : UIColor.systemRed
        backgroundNode = SKSpriteNode(color: backgroundColor, size: size)
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.alpha = 0.3
        backgroundNode.zPosition = -10
        addChild(backgroundNode)
        
        // Add gradient overlay
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if won {
            gradient.colors = [
                UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 0.8).cgColor,
                UIColor(red: 0.2, green: 0.4, blue: 0.1, alpha: 0.8).cgColor
            ]
        } else {
            gradient.colors = [
                UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 0.8).cgColor,
                UIColor(red: 0.4, green: 0.1, blue: 0.2, alpha: 0.8).cgColor
            ]
        }
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let gradientImage = UIImage.image(from: gradient)
        let gradientTexture = SKTexture(image: gradientImage)
        let gradientNode = SKSpriteNode(texture: gradientTexture, size: size)
        gradientNode.position = CGPoint(x: size.width/2, y: size.height/2)
        gradientNode.zPosition = -5
        addChild(gradientNode)
    }
    
    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = won ? "Victory!" : "Defeat"
        titleLabel.fontSize = 48
        titleLabel.fontColor = won ? .systemGreen : .systemRed
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        titleLabel.zPosition = 10
        
        // Add glow effect
        let glow = titleLabel.copy() as! SKLabelNode
        glow.fontColor = won ? .systemYellow : .systemOrange
        glow.alpha = 0.5
        glow.zPosition = 9
        addChild(glow)
        addChild(titleLabel)
        
        // Animate title
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        titleLabel.run(SKAction.repeatForever(sequence))
    }
    
    private func setupScore() {
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height * 0.65)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        levelLabel.text = "Level: \(level)"
        levelLabel.fontSize = 20
        levelLabel.fontColor = .lightGray
        levelLabel.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        levelLabel.zPosition = 10
        addChild(levelLabel)
    }
    
    private func setupMessage() {
        messageLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        
        if won {
            let messages = [
                "You have proven your divine strength!",
                "Rama's blessings are with you!",
                "The path of dharma leads to victory!",
                "Your courage has saved the kingdom!"
            ]
            messageLabel.text = messages.randomElement() ?? "Victory is yours!"
        } else {
            let messages = [
                "Even the greatest warriors face defeat...",
                "Learn from this experience and return stronger!",
                "The path of dharma requires perseverance!",
                "Rama's teachings guide us through challenges!"
            ]
            messageLabel.text = messages.randomElement() ?? "Try again with renewed strength!"
        }
        
        messageLabel.fontSize = 18
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: size.width/2, y: size.height * 0.45)
        messageLabel.zPosition = 10
        messageLabel.preferredMaxLayoutWidth = size.width * 0.8
        messageLabel.numberOfLines = 0
        messageLabel.horizontalAlignmentMode = .center
        addChild(messageLabel)
    }
    
    private func setupButtons() {
        let buttonSize = CGSize(width: 150, height: 50)
        let buttonSpacing: CGFloat = 70
        
        // Retry Button
        retryButton = createButton(title: "Retry", size: buttonSize, color: .systemOrange)
        retryButton.position = CGPoint(x: size.width/2, y: size.height * 0.3)
        addChild(retryButton)
        
        // Main Menu Button
        mainMenuButton = createButton(title: "Main Menu", size: buttonSize, color: .systemBlue)
        mainMenuButton.position = CGPoint(x: size.width/2, y: size.height * 0.3 - buttonSpacing)
        addChild(mainMenuButton)
        
        // Next Level Button (only show if won)
        if won && level < 6 {
            nextLevelButton = createButton(title: "Next Level", size: buttonSize, color: .systemGreen)
            nextLevelButton.position = CGPoint(x: size.width/2, y: size.height * 0.3 + buttonSpacing)
            addChild(nextLevelButton)
        }
    }
    
    private func createButton(title: String, size: CGSize, color: UIColor) -> SKSpriteNode {
        let button = SKSpriteNode(color: color, size: size)
        button.name = title.lowercased().replacingOccurrences(of: " ", with: "_")
        button.alpha = 0.9
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Medium")
        label.text = title
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = button.name
        button.addChild(label)
        
        return button
    }
    
    private func setupParticleEffects() {
        if won {
            // Victory particles
            let victoryParticles = SKEmitterNode()
            victoryParticles.particleBirthRate = 15
            victoryParticles.particleLifetime = 3.0
            victoryParticles.particleSpeed = 60
            victoryParticles.particleSpeedRange = 30
            victoryParticles.emissionAngle = CGFloat.pi
            victoryParticles.emissionAngleRange = CGFloat.pi / 2
            victoryParticles.particleAlpha = 0.8
            victoryParticles.particleAlphaRange = 0.3
            victoryParticles.particleScale = 0.2
            victoryParticles.particleScaleRange = 0.1
            victoryParticles.particleColor = .systemYellow
            victoryParticles.position = CGPoint(x: size.width/2, y: size.height)
            victoryParticles.zPosition = 5
            addChild(victoryParticles)
        } else {
            // Defeat particles
            let defeatParticles = SKEmitterNode()
            defeatParticles.particleBirthRate = 8
            defeatParticles.particleLifetime = 2.0
            defeatParticles.particleSpeed = 40
            defeatParticles.particleSpeedRange = 20
            defeatParticles.emissionAngle = CGFloat.pi
            defeatParticles.emissionAngleRange = CGFloat.pi / 3
            defeatParticles.particleAlpha = 0.6
            defeatParticles.particleAlphaRange = 0.3
            defeatParticles.particleScale = 0.15
            defeatParticles.particleScaleRange = 0.08
            defeatParticles.particleColor = .systemRed
            defeatParticles.position = CGPoint(x: size.width/2, y: size.height)
            defeatParticles.zPosition = 5
            addChild(defeatParticles)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        switch touchedNode.name {
        case "retry":
            retryLevel()
        case "main_menu":
            goToMainMenu()
        case "next_level":
            goToNextLevel()
        default:
            break
        }
    }
    
    private func retryLevel() {
        let gameScene = GameScene(size: size, level: level)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.doorway(withDuration: 0.8))
    }
    
    private func goToMainMenu() {
        let mainMenuScene = MainMenuScene(size: size)
        mainMenuScene.scaleMode = .aspectFill
        view?.presentScene(mainMenuScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    private func goToNextLevel() {
        let nextLevel = min(level + 1, 6)
        let gameScene = GameScene(size: size, level: nextLevel)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: SKTransition.doorway(withDuration: 0.8))
    }
}
