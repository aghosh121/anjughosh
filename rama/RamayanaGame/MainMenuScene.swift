import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var playButton: SKSpriteNode!
    private var settingsButton: SKSpriteNode!
    private var creditsButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTitle()
        setupButtons()
        setupParticleEffects()
    }
    
    private func setupBackground() {
        // Create a beautiful gradient background representing the divine realm
        let background = SKSpriteNode(color: .clear, size: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        // Add gradient effect
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradient.colors = [
            UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0).cgColor,
            UIColor(red: 0.3, green: 0.1, blue: 0.5, alpha: 1.0).cgColor,
            UIColor(red: 0.6, green: 0.2, blue: 0.3, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let gradientImage = UIImage.image(from: gradient)
        let texture = SKTexture(image: gradientImage)
        background.texture = texture
        
        addChild(background)
        backgroundNode = background
    }
    
    private func setupTitle() {
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleLabel.text = "The Ramayana"
        titleLabel.fontSize = 48
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        titleLabel.zPosition = 10
        
        // Add glow effect
        let glow = titleLabel.copy() as! SKLabelNode
        glow.fontColor = .yellow
        glow.alpha = 0.5
        glow.zPosition = 9
        addChild(glow)
        addChild(titleLabel)
        
        // Animate title
        let scaleUp = SKAction.scale(to: 1.1, duration: 2.0)
        let scaleDown = SKAction.scale(to: 1.0, duration: 2.0)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        titleLabel.run(SKAction.repeatForever(sequence))
    }
    
    private func setupButtons() {
        let buttonSize = CGSize(width: 200, height: 60)
        let buttonSpacing: CGFloat = 80
        
        // Play Button
        playButton = createButton(title: "Play Game", size: buttonSize, color: .systemGreen)
        playButton.position = CGPoint(x: size.width/2, y: size.height * 0.5)
        addChild(playButton)
        
        // Settings Button
        settingsButton = createButton(title: "Settings", size: buttonSize, color: .systemBlue)
        settingsButton.position = CGPoint(x: size.width/2, y: size.height * 0.5 - buttonSpacing)
        addChild(settingsButton)
        
        // Credits Button
        creditsButton = createButton(title: "Credits", size: buttonSize, color: .systemPurple)
        creditsButton.position = CGPoint(x: size.width/2, y: size.height * 0.5 - buttonSpacing * 2)
        addChild(creditsButton)
    }
    
    private func createButton(title: String, size: CGSize, color: UIColor) -> SKSpriteNode {
        let button = SKSpriteNode(color: color, size: size)
        button.name = title.lowercased().replacingOccurrences(of: " ", with: "_")
        
        let label = SKLabelNode(fontNamed: "AvenirNext-Medium")
        label.text = title
        label.fontSize = 20
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.name = button.name
        button.addChild(label)
        
        // Add rounded corners effect
        button.alpha = 0.9
        
        return button
    }
    
    private func setupParticleEffects() {
        // Add floating particles for divine effect
        if let particles = SKEmitterNode(fileNamed: "DivineParticles") {
            particles.position = CGPoint(x: size.width/2, y: size.height)
            particles.zPosition = 5
            addChild(particles)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        switch touchedNode.name {
        case "play_game":
            navigateToLevelSelect()
        case "settings":
            showSettings()
        case "credits":
            showCredits()
        default:
            break
        }
    }
    
    private func navigateToLevelSelect() {
        let levelSelectScene = LevelSelectScene(size: size)
        levelSelectScene.scaleMode = .aspectFill
        view?.presentScene(levelSelectScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    private func showSettings() {
        // TODO: Implement settings scene
        print("Settings tapped")
    }
    
    private func showCredits() {
        // TODO: Implement credits scene
        print("Credits tapped")
    }
}

// Helper extension for gradient
extension UIImage {
    static func image(from layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
